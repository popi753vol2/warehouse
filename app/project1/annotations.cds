using WarehouseService as service from '../../srv/warehouseService';

annotate service.Products with @(
    UI.HeaderInfo                : {
        TypeName      : 'Product',
        TypeNamePlural: 'Products',
        Title         : {
            $Type: 'UI.DataField',
            Value: name,
        },
        Description   : {
            $Type: 'UI.DataField',
            Value: descr,
        },
    },
    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Label: 'Name',
                Value: name,
            },
            {
                $Type: 'UI.DataField',
                Value: category_ID,
                Label: 'Category',
            },
            {
                $Type: 'UI.DataField',
                Label: 'Description',
                Value: descr,
            },
            {
                $Type: 'UI.DataField',
                Value: supplier_ID,
                Label: 'Supplier',
            },
            {
                $Type: 'UI.DataField',
                Label: 'Price',
                Value: price,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Currency',
                Value: currency_code,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Size',
                Value: size,
            },
            {
                $Type: 'UI.DataField',
                Label: 'Stock',
                Value: stock,
            },
        ],
    },
    UI.Facets                    : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'GeneratedFacet1',
        Label : 'General Information',
        Target: '@UI.FieldGroup#GeneratedGroup',
    }, ],
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Label: 'Name',
            Value: name,
        },
        {
            $Type: 'UI.DataField',
            Value: category.title,
            Label: 'Category',
        },
        {
            $Type: 'UI.DataField',
            Label: 'Description',
            Value: descr,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Price',
            Value: price,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Currency',
            Value: currency_code,
        },
        {
            $Type: 'UI.DataField',
            Label: 'Size',
            Value: size,
        },
        {
            $Type: 'UI.DataField',
            Value: stock,
            Label: 'Stock',
        },
    ],
);

annotate service.Products with {
    category @(
        Common.Text           : category.title,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Categories',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: category_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'title',
                },
            ],
        }
    );

    supplier @(
        Common.Text           : supplier.name,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Suppliers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: supplier_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
            ],
        }
    );
};

annotate service.Orders with @(
    UI.HeaderInfo                : {
        TypeName      : 'Order',
        TypeNamePlural: 'Orders',
        Title         : {
            $Type: 'UI.DataField',
            Value: ID,
        },
    },
    UI.Facets                    : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'GeneratedFacet1',
            Label : 'General Information',
            Target: '@UI.FieldGroup#GeneratedGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'OrderItems',
            Label : 'Items',
            Target: 'products/@UI.LineItem',
        },
    ],

    UI.FieldGroup #GeneratedGroup: {
        $Type: 'UI.FieldGroupType',
        Data : [

            {
                $Type: 'UI.DataField',
                Value: customer_ID,
                Label: 'Customer',
            },
            {
                $Type: 'UI.DataField',
                Label: 'Order Date',
                Value: orderDate,
            },
            {
                $Type: 'UI.DataField',
                Value: createdBy,
            },
            {
                $Type: 'UI.DataField',
                Value: modifiedBy,
            },
            {
                $Type: 'UI.DataField',
                Value: totalPrice,
                Label: 'Total Price',
            },
            {
                $Type: 'UI.DataField',
                Label: 'Currency',
                Value: currency_code,
            },
        ],
    },
    UI.LineItem                  : [
        {
            $Type: 'UI.DataField',
            Value: ID,
            Label: 'ID',
        },
        {
            $Type: 'UI.DataField',
            Value: orderDate,
            Label: 'Order Date',
        },
        {
            $Type: 'UI.DataField',
            Value: customer.name,
            Label: 'Name',
        },
        {
            $Type: 'UI.DataField',
            Value: createdBy,
        },
        {
            $Type: 'UI.DataField',
            Value: modifiedBy,
        },
        {
            $Type: 'UI.DataField',
            Value: totalPrice,
            Label: 'Total Price',
        },
        {
            $Type: 'UI.DataField',
            Value: currency_code,
        },
    ]
);

annotate service.Orders with {
    totalPrice @readonly;

    customer   @(
        Common.FieldControl  : customerFieldControl,
        Common.Text           : customer.name,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type         : 'Common.ValueListType',
            CollectionPath: 'Customers',
            Parameters    : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: customer_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
            ],
        }
    );
};

annotate service.Orders with @Capabilities.InsertRestrictions.Insertable: false;

annotate service.Products_Orders with @(UI.LineItem: [
    {
        $Type: 'UI.DataField',
        Label: 'Product',
        Value: product_ID,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Price',
        Value: product.price,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Currency',
        Value: product.currency_code,
    },
    {
        $Type: 'UI.DataField',
        Label: 'Quantity',
        Value: quantity,
    },
], );

// Value help for product selection in the order items sub-table.
// Points to OrderProducts (read-only Products projection) so it
// shows all products — duplicates are rejected by the backend.
annotate service.Products_Orders with {
    product @(
        Common.Text           : product.name,
        Common.TextArrangement: #TextOnly,
        Common.ValueList      : {
            $Type          : 'Common.ValueListType',
            CollectionPath : 'OrderProducts',
            Parameters     : [
                {
                    $Type            : 'Common.ValueListParameterOut',
                    LocalDataProperty: product_ID,
                    ValueListProperty: 'ID',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'price',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'currency_code',
                },
            ],
        }
    );
};

