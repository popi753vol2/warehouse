using {warehouse} from '../db/warehouseSchema';

service WarehouseService @(odata: '/warehouse') {

    @(restrict: [
        {
            grant: 'READ',
            to   : 'authenticated-user'
        },
        {
            grant: [
                'CREATE',
                'UPDATE',
                'DELETE'
            ],
            to   : [
                'Admin',
                'Manager'
            ]
        }
    ])
    @odata.draft.enabled
    entity Products        as projection on warehouse.Products;

    entity Suppliers       as projection on warehouse.Suppliers;
    entity Categories      as projection on warehouse.Categories;

    @(restrict: [
        {
            grant: 'READ',
            to   : 'Customer',
            where: (customer.name = $user)
        },
        {
            grant: [
                'READ',
                'UPDATE',
                'DELETE'
            ],
            to   : [
                'Manager',
                'Admin'
            ]
        }
    ])
    entity Orders          as projection on warehouse.Orders;

    action submitOrder(customer_ID: UUID, currency_code: String(3), date: Date, items: array of {
        product_ID : UUID;
        quantity   : Integer
    })               returns Orders;

    entity Products_Orders as projection on warehouse.Products_Orders;
    entity Customers       as projection on warehouse.Customers;

    action getUser() returns {
        isCustomer : Boolean;
        user       : String;
        ID         : UUID;
    };

}

annotate WarehouseService with @(requires: 'authenticated-user');
