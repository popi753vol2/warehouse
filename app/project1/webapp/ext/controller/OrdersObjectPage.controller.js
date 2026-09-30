sap.ui.define([
    "sap/ui/core/mvc/ControllerExtension"
], function (ControllerExtension) {
    "use strict";

    return ControllerExtension.extend("project1.ext.controller.ObjectPageExt", {

        onGoBackToOrders: function () {
            this.base.getExtensionAPI().getRouting()
                .navigateToRoute("OrdersListRoute");
        }
    });
});

