import cds from '@sap/cds';

export default class WarehouseService extends cds.ApplicationService {
    async init() {

        const { Products, Orders, Customers, Products_Orders } = this.entities;

        const fetchRates = async (baseCurrency) => {
            try {
                const response = await fetch(
                    `https://open.er-api.com/v6/latest/${encodeURIComponent(baseCurrency)}`
                );
                if (!response.ok) throw new Error('Exchange-rate request failed');

                const data = await response.json();
                if (data.result !== 'success' || !data.rates) {
                    throw new Error('Exchange-rate response was invalid');
                }

                return data.rates;
            } catch (error) {
                return req.error(500, 'Failed to fetch currency rates / try again later');
            }
        };

        const calculateTotalPrice = async (items, currencyCode) => {
            const products = await SELECT.from(Products).where({ ID: { in: items.map(item => item.product_ID) } });

            const rates = await fetchRates(currencyCode);

            const totalPrice = items.reduce((total, item) => {
                const product = products.find(p => p.ID === item.product_ID);
                if (!product) {
                    throw new Error(`Product with ID ${item.product_ID} not found`);
                }

                const exchangeRate = rates[product.currency_code].toFixed(4);
                const productPriceInTargetCurrency = product.price / exchangeRate;

                return total + (productPriceInTargetCurrency.toFixed(4) * (item.quantity || 1));
            }, 0);

            return totalPrice;
        }

        this.on('getUser', async (req) => {
            const user = req.user;
            const isCustomer = user.is('Customer');

            if (isCustomer) {
                const customer = await SELECT.one(Customers).where({ name: user.id });
                if (!customer) return req.error(404, `No customer record found for user ${user.id}`);
                return {
                    isCustomer: true,
                    user: user.id,
                    ID: customer.ID
                };
            } else {
                return {
                    isCustomer: false,
                    user: user.id,
                    ID: null
                };
            }
        });

        const setCustomerFieldControl = (orders, req) => {
            const value = req.user.is('Admin') || req.user.is('Manager') ? 3 : 1;
            const results = Array.isArray(orders) ? orders : [orders];

            for (const order of results) {
                if (order) order.customerFieldControl = value;
            }
        };

        this.after('EDIT', Orders, setCustomerFieldControl);

        this.on('submitOrder', async (req) => {
            const { customer_ID, currency_code, date, items } = req.data;

            if (!customer_ID) return req.error(400, 'Customer is required');
            if (!currency_code) return req.error(400, 'Currency is required');
            if (!date) return req.error(400, 'Order Date is required');
            if (!items || !Array.isArray(items) || items.length === 0) {
                return req.error(400, 'At least one item is required to submit an order');
            }

            const totalPrice = await calculateTotalPrice(items, currency_code);

            const order = {
                ID: cds.utils.uuid(),
                orderDate: date ?? new Date().toISOString().split('T')[0],
                customer_ID,
                currency_code,
                totalPrice,
            };

            await INSERT.into(Orders).entries(order);

            const productOrders = items.map(item => ({
                ID: cds.utils.uuid(),
                product_ID: item.product_ID,
                order_ID: order.ID,
                quantity: item.quantity || 1,
            }));

            await INSERT.into(Products_Orders).entries(productOrders);

            return SELECT.one(Orders).where({ ID: order.ID });
        });

        this.before("UPDATE", Orders, async (req) => {
            console.log("Before UPDATE hook triggered for Orders");

            const { ID, currency_code } = req.data;

            const productsOrders = await SELECT.from(Products_Orders)
                .where({ order_ID: ID });

            const updatedTotalPrice = await calculateTotalPrice(productsOrders, currency_code);

            req.data.totalPrice = updatedTotalPrice;
        }
        );

        return super.init();
    }
}
