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
    entity Products         as projection on warehouse.Products;
    entity Suppliers        as projection on warehouse.Suppliers;
    entity Categories       as projection on warehouse.Categories;
    entity Orders           as projection on warehouse.Orders;
    entity Products_Orders  as projection on warehouse.Products_Orders;
    entity Customers        as projection on warehouse.Customers;
    
}

annotate WarehouseService with @(requires: 'authenticated-user');

