using WarehouseService as service from '../../srv/warehouseService';
annotate service.Products with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'descr',
                Value : descr,
            },
            {
                $Type : 'UI.DataField',
                Label : 'price',
                Value : price,
            },
            {
                $Type : 'UI.DataField',
                Label : 'size',
                Value : size,
            },
            {
                $Type : 'UI.DataField',
                Label : 'currency_code',
                Value : currency_code,
            },
            {
                $Type : 'UI.DataField',
                Label : 'stock',
                Value : stock,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'Name',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Value : category.title,
            Label : 'Category',
        },
        {
            $Type : 'UI.DataField',
            Label : 'Description',
            Value : descr,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Price',
            Value : price,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Currency',
            Value : currency_code,
        },
        {
            $Type : 'UI.DataField',
            Label : 'Size',
            Value : size,
        },
        {
            $Type : 'UI.DataField',
            Value : stock,
            Label : 'Stock',
        },
    ],
);

annotate service.Products with {
    supplier @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Suppliers',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : supplier_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'name',
            },
        ],
    }
};

annotate service.Products with {
    category @Common.ValueList : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Categories',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : category_ID,
                ValueListProperty : 'ID',
            },
            {
                $Type : 'Common.ValueListParameterDisplayOnly',
                ValueListProperty : 'title',
            },
        ],
    }
};

