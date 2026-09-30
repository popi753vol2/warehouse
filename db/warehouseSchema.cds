using {
  Currency,
  managed,
} from '@sap/cds/common';

namespace warehouse;

entity Products : managed {
  key ID       : UUID;

      @mandatory
      name     : String(100);

      @mandatory
      descr    : String(500);

      @mandatory
      @assert.range: [
        0.01,
        99999
      ]
      price    : Decimal(8, 2);

      @mandatory
      @assert.range: [
        0.1,
        100
      ]
      size     : Decimal(4, 2);

      @mandatory
      @assert.target
      currency : Currency;

      @mandatory
      @assert.range: [
        0,
        99999
      ]
      stock    : Integer;

      @mandatory
      @assert.target
      supplier : Association to Suppliers not null;

      @mandatory
      @assert.target
      category : Association to Categories not null;
}

entity Suppliers : managed {
  key ID       : UUID;
      name     : String;
      products : Association to many Products
                   on products.supplier = $self;
}

entity Categories : managed {
  key ID       : UUID;
      title    : String;
      products : Association to many Products
                   on products.category = $self;
}

entity Products_Orders : managed {
  key ID       : UUID;
      product  : Association to Products;
      order    : Association to Orders;
      quantity : Integer;
}

entity Orders : managed {
  key ID         : UUID;
      orderDate  : Date;
      totalPrice : Decimal(10, 2);
      currency   : Currency;
      customer   : Association to Customers;
      products   : Association to many Products_Orders
                     on products.order.ID = $self.ID;
}

entity Customers_Orders : managed {
  key ID       : UUID;
      customer : Association to Customers;
      order    : Association to Orders;
}

entity Customers : managed {
  key ID     : UUID;
      name   : String;
      email  : String;
      orders : Association to Customers_Orders
                 on orders.customer.ID = $self.ID;
}
