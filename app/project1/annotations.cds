using WarehouseService as service from '../../srv/warehouseService';

annotate service.Products with @(
    UI.HeaderInfo: {
        TypeName: 'Product',
        TypeNamePlural: 'Products',
        Title: {
            $Type: 'UI.DataField',
            Value: name,
        },
        Description: {
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
