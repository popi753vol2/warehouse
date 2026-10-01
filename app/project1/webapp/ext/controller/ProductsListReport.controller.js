sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension",
    "sap/ui/model/json/JSONModel",
    "sap/ui/core/Fragment",
    "sap/m/MessageBox"
], function (ControllerExtension, JSONModel, Fragment, MessageBox) {
    "use strict";

    return ControllerExtension.extend("project1.ext.controller.ListReportExt", {

        onGoToOrders: function () {
            this.base.getExtensionAPI().getRouting()
                .navigateToRoute("OrdersListRoute");
        },

        onOpenCreateOrderDialog: async function (oEvent, aSelectedContexts) {

            const oModel = this.getView().getModel();
            const oOperation = oModel.bindContext("/getUser(...)");

            await oOperation.execute();
            const user = oOperation.getBoundContext().getObject();

            let aContexts;
            if (aSelectedContexts && aSelectedContexts.length) {
                aContexts = aSelectedContexts;
            } else if (this.base && this.base.getExtensionAPI) {
                aContexts = this.base.getExtensionAPI().getSelectedContexts();
            } else {
                aContexts = [];
            }

            if (!aContexts || aContexts.length === 0) {
                MessageBox.warning("Please select at least one product.");
                return;
            }

            const items = aContexts.map((oCtx) => {
                const oData = oCtx.getObject();
                return {
                    product_ID: oData.ID,
                    name: oData.name,
                    quantity: 1
                };
            });

            const oView = this.base.getView();

            if (!this.dialog) {
                this.dialog = Fragment.load({
                    id: oView.getId(),
                    name: "project1.ext.fragment.CreateOrderDialog",
                    controller: this
                }).then(function (dialog) {
                    oView.addDependent(dialog);
                    return dialog;
                });
            }

            this.dialog.then((oDialog) => {
                const oComboBox = this.base.getView().byId("customerComboBox");

                if (user.isCustomer) {
                    oComboBox.setSelectedKey(user.ID);
                    oComboBox.setEnabled(false);
                }

                const oItemsModel = new JSONModel(items);
                oDialog.setModel(oItemsModel, "orderItems");

                const oConfigModel = new JSONModel({
                    customer_ID: user.ID,
                    orderDate: new Date().toISOString().split("T")[0],
                    currency_code: ""
                });
                oDialog.setModel(oConfigModel, "orderConfig");
                oDialog.open();

            });
        },

        onConfirmOrder: async function () {
            const oDialog = await this.dialog;
            const items = oDialog.getModel("orderItems").getData();
            const oConfig = oDialog.getModel("orderConfig").getData();

            const CustomerID = oConfig.customer_ID;
            const CurrencyCode = oConfig.currency_code;
            const OrderDate = oConfig.orderDate;

            if (!CustomerID) {
                MessageBox.error("Please select or enter a Customer ID.");
                return;
            }
            if (!CurrencyCode) {

                MessageBox.error("Please select or enter a Currency Code.");
                return;
            }
            if (!OrderDate) {
                MessageBox.error("Please select or enter an Order Date.");
                return;
            }

            const payloadItems = items.map((item) => {
                return {
                    "product_ID": item.product_ID,
                    "quantity": Number(item.quantity) || 1
                };
            });

            oDialog.setBusy(true);
            try {
                const oModel = this.base.getModel();
                const oOperation = oModel.bindContext("/submitOrder(...)");
                oOperation.setParameter("customer_ID", CustomerID);
                oOperation.setParameter("currency_code", CurrencyCode);
                oOperation.setParameter("date", OrderDate);
                oOperation.setParameter("items", payloadItems);

                await oOperation.execute();

                oDialog.setBusy(false);
                oDialog.close();

                MessageBox.success("Order created successfully!");
                this.base.getExtensionAPI().refresh();
            } catch (oError) {
                oDialog.setBusy(false);
                MessageBox.error(oError.message || "Failed to create order");
            }
        },

        onCancelOrder: function () {
            if (this.dialog) {
                this.dialog.then((oDialog) => {
                    oDialog.close();
                });
            }
        }

    });
});

