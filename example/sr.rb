require_relative '../lib/openapi'

module Helpers
  def resource_id(value)
    OpenAPI::DSL::Proxy::Schema.object do
      property :id, string
      property :type, string { enum value }
    end
  end
  module_function :resource_id

  def relationship_object(value)
    OpenAPI::DSL::Proxy::Schema.object do
      property :links, (object do
        property :self, string { description 'Link to the relationship endpoint.' }
        property :related, string { description 'Link to the related entity.' }
        property :data, Helpers.resource_id(value)
      end)
    end
  end
  module_function :relationship_object

  def attributes(&block)
    OpenAPI::DSL::Proxy::Schema.object do
      property :attributes, object(&block)
    end
  end
  module_function :attributes

  def collection_links
    OpenAPI::DSL::Proxy::Schema.object do
      property :links, (object do
        property :self, string { description 'A link to this resource.' }
        property :first, string { description 'The first page of data.' }
        property :last, string { description 'The last page of data.' }
        property :prev, string { description 'The previous page of data.' }
        property :next, string { description 'The next page of data.' }
      end)
    end
  end
  module_function :collection_links

  def relationship_links
    OpenAPI::DSL::Proxy::Schema.object do
      property :links, (object do
        property :self, string { description 'A link to this resource.' }
        property :related, string { description 'A link to the related resource(s).' }
      end)
    end
  end
  module_function :relationship_links

  def resource_links
    OpenAPI::DSL::Proxy::Schema.object do
      property :links, (object do
        property :self, string { description 'A link to this resource.' }
      end)
    end
  end
  module_function :resource_links

  def error
    OpenAPI::DSL::Proxy::Schema.object do
      property :id, string { description 'A unique identifier for this particular occurrence of the problem.' }
      property :status, string { description 'The HTTP status code applicable to this problem, expressed as a string value.' }
      property :code, string { description 'An application-specific error code, expressed as a string value.' }
      property :title, string { description 'A short, human-readable summary of the problem.' }
      property :detail, string { description 'A human-readable explanation specific to this occurrence of the problem.' }
      property :source, object { description 'An object containing references to the source of the error.' }
      property :meta, object { description 'A meta object containing non-standard meta-information about the error.' }
    end
  end
  module_function :error
end

module Responses
  def not_found
    response('Not found')
  end
  module_function :not_found

  def forbidden
    response('Forbidden')
  end
  module_function :forbidden

  def unauthorized
    response('Unauthorized')
  end
  module_function :unauthorized

  def conflict
    response('Conflict')
  end
  module_function :conflict

  def response(desc)
    OpenAPI::DSL::Proxy::Response.define do
      description desc
      object do
        property :errors, array(of: Helpers.error)
      end
    end
  end
  module_function :response
end

module Parameters
  def page_number
    OpenAPI::DSL::Proxy::Parameter.query do
      name 'page[number]'
      description "The collection's page number to return."
      integer { default 1 }
    end
  end
  module_function :page_number

  def page_size
    OpenAPI::DSL::Proxy::Parameter.query do
      name 'page[size]'
      description 'The number of collection items to return per page.'
      integer { default 10 }
    end
  end
  module_function :page_size

  def include_
    OpenAPI::DSL::Proxy::Parameter.query do
      name 'include'
      description 'A comma-separated list of relationships to include in the response.'
      string
    end
  end
  module_function :include_

  def id(desc)
    OpenAPI::DSL::Proxy::Parameter.path do
      name 'id'
      description desc
      required true
      string
    end
  end
  module_function :id
end

module Customers
  def customer
    OpenAPI::DSL::Proxy::Schema.define do
      title 'Customer'
      all_of Helpers.resource_id('customer'), Customers.attributes
    end
  end
  module_function :customer

  def resource_id
    Helpers.resource_id('customer')
  end
  module_function :resource_id

  def relationship_object
    Helpers.relationship_object('customer')
  end
  module_function :relationship_object

  def attributes
    Helpers.attributes do
      property :firstName, string
      property :lastName, string
    end
  end
  module_function :attributes
end

module Items
  def item
    OpenAPI::DSL::Proxy::Schema.define do
      title 'Item'
      all_of Items.resource_id, Items.attributes
    end
  end
  module_function :item

  def resource_id
    Helpers.resource_id('item')
  end
  module_function :resource_id

  def relationship_object
    Helpers.relationship_object('item')
  end
  module_function :relationship_object

  def attributes
    Helpers.attributes do
      property :description, string
      property :createdAt, datetime
      property :updatedAt, datetime
    end
  end
  module_function :attributes
end

module SalesOrderLines
  def sales_order_line
    OpenAPI::DSL::Proxy::Schema.define do
      title 'Sales Order Line'
      all_of SalesOrderLines.resource_id, SalesOrderLines.attributes, SalesOrderLines.relationships
    end
  end
  module_function :sales_order_line

  def resource_id
    Helpers.resource_id('salesOrderLine')
  end
  module_function :resource_id

  def relationship_object
    Helpers.relationship_object('salesOrderLine')
  end
  module_function :relationship_object

  def attributes
    Helpers.attributes do
      property :qty, double
      property :unitCost, double
      property :createdAt, datetime
      property :updatedAt, datetime
    end
  end
  module_function :attributes

  def relationships
    OpenAPI::DSL::Proxy::Schema.object do
      property :relationships, (object do
        property :item, Items.relationship_object
      end)
    end
  end
  module_function :relationships

  def collection_response
    OpenAPI::DSL::Proxy::Schema.define do
      all_of Helpers.collection_links, (object do
        property :data, array(of: SalesOrderLines.sales_order_line)
      end)
    end
  end
  module_function :collection_response
end

module SalesOrders
  def sales_order
    OpenAPI::DSL::Proxy::Schema.define do
      title 'Sales Order'
      all_of SalesOrders.resource_id, SalesOrders.attributes, SalesOrders.relationships
    end
  end
  module_function :sales_order

  def resource_id
    Helpers.resource_id('salesOrder')
  end
  module_function :resource_id

  def relationship_object
    Helpers.relationship_object('salesOrder')
  end
  module_function :relationship_object

  def attributes
    Helpers.attributes do
      property :status, string { enum %w(pending open canceled closed) }
      property :recalculate, (boolean do
        default true
        description "Whether or not the order's taxes and promotions should be recalculated on change."
      end)
      property :createdAt, datetime
      property :updatedAt, datetime
    end
  end
  module_function :attributes

  def relationships
    OpenAPI::DSL::Proxy::Schema.object do
      property :relationships, (object do
        property :customer, Customers.relationship_object
        property :station, Stations.relationship_object
        property :createdByUser, Users.relationship_object
        property :updatedByUser, Users.relationship_object
        property :lines, array(of: SalesOrderLines.sales_order_line)
      end)
    end
  end
  module_function :relationships

  def included
    OpenAPI::DSL::Proxy::Schema.object do
      property :included, array(of: SalesOrders.included_schemas)
    end
  end
  module_function :included

  def included_schemas
    OpenAPI::DSL::Proxy::Schema.define do
      one_of \
        Customers.customer,
        SalesOrderLines.sales_order_line,
        Stations.relationship_object,
        Users.relationship_object
    end
  end
  module_function :included_schemas

  def request_body
    OpenAPI::DSL::Proxy::Schema.object do
      title 'Sales Order'
      required 'data'
      property :data, (schema do
        required 'type'
        all_of SalesOrders.resource_id, SalesOrders.attributes, SalesOrders.relationships
      end)
    end
  end
  module_function :request_body

  def response
    OpenAPI::DSL::Proxy::Schema.define do
      all_of SalesOrders.resource_id, (object do
        property :data, (object do
          all_of SalesOrders.sales_order
        end)
      end)
    end
  end
  module_function :response

  def collection_response
    OpenAPI::DSL::Proxy::Schema.define do
      all_of Helpers.collection_links, (object do
        property :data, array(of: SalesOrders.sales_order)
      end)
    end
  end
  module_function :collection_response

  module Customer
    def response
      OpenAPI::DSL::Proxy::Schema.define do
        all_of Helpers.relationship_links, (object do
          property :data, (object do
            all_of Customers.resource_id
          end)
        end)
      end
    end
    module_function :response
  end

  module Lines
    def response
      OpenAPI::DSL::Proxy::Schema.define do
        all_of Helpers.relationship_links, (object do
          property :data, array(of: SalesOrderLines.sales_order_line)
        end)
      end
    end
    module_function :response
  end
end

module Stations
  def station
    OpenAPI::DSL::Proxy::Schema.define do
      title 'Station'
      all_of Stations.resource_id, Stations.attributes
    end
  end
  module_function :station

  def resource_id
    Helpers.resource_id('station')
  end
  module_function :resource_id

  def relationship_object
    Helpers.relationship_object('station')
  end
  module_function :relationship_object

  def attributes
    Helpers.attributes do
      property :name, string
      property :active, boolean
    end
  end
  module_function :attributes
end

module Users
  def user
    OpenAPI::DSL::Proxy::Schema.define do
      title 'User'
      all_of Users.resource_id, Users.attributes
    end
  end
  module_function :user

  def resource_id
    Helpers.resource_id('user')
  end
  module_function :resource_id

  def relationship_object
    Helpers.relationship_object('user')
  end
  module_function :relationship_object

  def attributes
    Helpers.attributes do
      property :firstName, string
      property :lastName, string
    end
  end
  module_function :attributes
end

module Paths
  def sales_orders
    OpenAPI::DSL::Proxy::PathItem.define do
      get do
        operation_id 'listSalesOrders'
        tags 'sales-orders'
        description 'Returns a paginated collection of `Sales Orders` objects.'
        oauth2 %w(sales.order.view sales.order.manage)
        parameters Parameters.page_number, Parameters.page_size, Parameters.include_

        response '200' do
          description 'OK'
          schema SalesOrders.collection_response
        end

        response '404', Responses.not_found
      end

      post do
        operation_id 'createSalesOrder'
        tags 'sales-orders'
        description 'Creates a `Sales Order`.'
        oauth2 %w(sales.order.edit sales.order.manage)

        request_body do
          description 'A `Sales Order`.'
          required true
          schema SalesOrders.request_body
        end

        response '201' do
          header 'Location' do
            string
            description 'Location of the newly created resource.'
          end
          description 'Sales Order Created.'
          schema SalesOrders.response
        end

        response '404', Responses.not_found
        response '409', Responses.conflict
      end
    end
  end
  module_function :sales_orders

  def sales_order
    OpenAPI::DSL::Proxy::PathItem.define do
      get do
        operation_id 'fetchSalesOrder'
        tags 'sales-orders'
        description 'Returns a `Sales Order`.'
        oauth2 %w(sales.order.view sales.order.manage)

        parameters Parameters.id('Sales Order ID.'), Parameters.include_

        response '200' do
          description 'OK'
          schema SalesOrders.sales_order
        end

        response '404', Responses.not_found
      end

      patch do
        operation_id 'updateSalesOrder'
        tags 'sales-orders'
        description 'Updates a `Sales Order`.'
        oauth2 %w(sales.order.edit sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        request_body do
          description 'A `Sales Order`.'
          required true
          schema SalesOrders.request_body
        end

        response '200' do
          description 'Sales Order Updated.'
          schema SalesOrders.response
        end

        response '404', Responses.not_found
        response '409', Responses.conflict
      end

      delete do
        operation_id 'deleteSalesOrder'
        tags 'sales-orders'
        description 'Deletes a `Sales Order`.'
        oauth2 %w(sales.order.edit sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        response '204' do
          description 'Sales Order Deleted.'
        end

        response '404', Responses.not_found
      end
    end
  end
  module_function :sales_order

  def customer
    OpenAPI::DSL::Proxy::PathItem.define do
      get do
        operation_id 'fetchCustomerForSalesOrder'
        tags 'sales-orders'
        description 'Returns the `Customer` for a `Sales Order`.'
        oauth2 %w(sales.order.view sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        response '200' do
          description 'OK'
          schema do
            title 'Sales Order Customer'
            all_of SalesOrders::Customer.response
          end
        end

        response '404', Responses.not_found
      end

      patch do
        operation_id 'replaceCustomerOnSalesOrder'
        tags 'sales-orders'
        description 'Updates the related `Customer` for a `Sales Order`.'
        oauth2 %w(sales.order.edit sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        request_body do
          description 'A `Customer Resource ID`. `null` data will clear the relationship.'
          required true
          object do
            title 'Sales Order Customer Resource ID'
            required 'data'
            property :data, SalesOrders.resource_id
          end
        end

        response '204' do
          description 'Sales Order Customer Updated.'
        end

        response '403', Responses.forbidden
      end
    end
  end
  module_function :customer

  def lines
    OpenAPI::DSL::Proxy::PathItem.define do
      get do
        operation_id 'fetchSalesOrderLinesForSalesOrder'
        tags 'sales-orders'
        description 'Returns all `Sales Order Lines` for a `Sales Order`.'
        oauth2 %w(sales.order.view sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        response '200' do
          description 'OK'
          schema do
            title 'Sales Order Lines'
            all_of SalesOrders::Lines.response
          end
        end

        response '404', Responses.not_found
      end

      post do
        operation_id 'addSalesOrderLinesToSalesOrder'
        tags 'sales-orders'
        description 'Adds related `Sales Order Lines` to a `Sales Order`.'
        oauth2 %w(sales.order.edit sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        request_body do
          description 'A collection of `Sales Order Line Resource ID`.'
          required true
          object do
            title 'Sales Order Line Resource IDs'
            required 'data'
            property :data, array(of: SalesOrders.resource_id)
          end
        end

        response '204' do
          description 'Sales Order Lines Added.'
        end

        response '403', Responses.forbidden
      end

      patch do
        operation_id 'replaceSalesOrderLinesOnSalesOrder'
        tags 'sales-orders'
        description 'Updates all related `Sales Order Lines` for a `Sales Order`.'
        oauth2 %w(sales.order.edit sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        request_body do
          description 'A collection of `Sales Order Line Resource ID`. An empty array will clear all related resources.'
          required true
          object do
            title 'Sales Order Line Resource IDs'
            required 'data'
            property :data, array(of: SalesOrders.resource_id)
          end
        end

        response '204' do
          description 'Sales Order Lines Updated.'
        end

        response '403', Responses.forbidden
      end

      delete do
        operation_id 'removeSalesOrderLinesOnSalesOrder'
        tags 'sales-orders'
        description 'Removes all related `Sales Order Lines` from a `Sales Order`.'
        oauth2 %w(sales.order.edit sales.order.manage)

        parameter Parameters.id('Sales Order ID.')

        request_body do
          description 'A collection of `Sales Order Line Resource ID`.'
          required true
          object do
            title 'Sales Order Line Resource IDs'
            required 'data'
            property :data, array(of: SalesOrders.resource_id)
          end
        end

        response '204' do
          description 'Sales Order Lines Removed.'
        end

        response '403', Responses.forbidden
      end
    end
  end
  module_function :lines
end

SR = OpenAPI.define do
  title 'Springboard Retail API'
  version '2.0.0'

  server do
    url 'https://{tenant}.myspringboard.us/api/v2'
    variable 'tenant' do
      default 'demo'
      description "Tenant's subdomain"
    end
  end

  path '/sales-orders', Paths.sales_orders
  path '/sales-orders/{id}', Paths.sales_order
  path '/sales-orders/{id}/relationships/customer', Paths.customer
  path '/sales-orders/{id}/relationships/lines', Paths.lines

  oauth2 'This API uses OAuth 2. [More info](https://api.example.com/docs/auth)' do
    authorization_url 'https://myspringboard.us/oauth/authorize'
    token_url 'https://myspringboard.us/api/oauth/token'
    scopes \
      'cash_drawer.close': 'Close cash drawer',
      'cash_drawer.manage': 'Manage cash drawers',
      'cash_drawer.open': 'Open cash drawer',
      'cash_paid.create': 'Create cash paid out/in transactions',
      'cash_paid.read': 'View cash paid out/in history',
      'custom_field.manage': 'Manage custom fields',
      'customer.export': 'Export customers',
      'customer.manage': 'Create and manage customers',
      'customer.merge': 'Merge customers',
      'customer.read': 'View customers',
      'financial.event.read': 'View financial events',
      'financial.manage': 'Manage financial configuration',
      'gift_card.manage': 'Manage gift cards and adjust balances',
      'grid_templates.manage': 'Manage grid templates',
      'integrations.manage': 'Manage integrations',
      'inventory.adjustment.manage': 'Manage adjustments',
      'inventory.adjustment.read': 'View adjustments',
      'inventory.bin.manage': 'Update bin locations',
      'inventory.counts.create': 'Create physical counts',
      'inventory.counts.finalize': 'Review discrepancies and accept physical counts',
      'inventory.threshold.manage': 'Edit item reorder points and target quantity',
      'inventory.transaction.read': 'View inventory history',
      'inventory.transfer.read': 'View transfers',
      'inventory.transfer.recall_shipment': 'Recall transfer shipments',
      'inventory.transfer.receive': 'Receive transfers',
      'inventory.transfer.resolve_discrepancies': 'Resolve transfer discrepancies',
      'inventory.transfer.select_from_shipment': 'Select receipt items from transfer shipment',
      'inventory.transfer.ship': 'Ship transfers',
      'inventory.values.read': 'View current inventory values',
      'inventory.vendor.read': 'View inventory vendor information',
      'item.create_on_fly': 'Create items on the fly',
      'item.export': 'Export items',
      'item.manage': 'Manage items and grids',
      'item.merge': 'Merge items',
      'item.view_cost': 'View item cost and margin information',
      'location.manage': 'Manage locations',
      'location.read': 'View locations',
      'payment.manage': 'Manage payments',
      'payment.read': 'View payments',
      'payment_type.manage': 'Manage payment types',
      'pos.manage': 'Manage POS settings',
      'purchasing.order.manage': 'Manage orders',
      'purchasing.order.read.canceled': 'View canceled orders',
      'purchasing.order.read.closed': 'View closed orders',
      'purchasing.order.read.open': 'View open orders',
      'purchasing.order.read.pending': 'View pending orders',
      'purchasing.order.read': 'View all orders',
      'purchasing.receipt.manage': 'Manage receipts',
      'purchasing.receipt.read': 'View receipts',
      'purchasing.receipt.select_from_order': 'Select receipt items from purchase order',
      'purchasing.return.manage': 'Manage returns',
      'purchasing.return.read': 'View returns',
      'purchasing.vendor.manage': 'Manage vendors',
      'purchasing.vendor.read': 'View vendors',
      'reason_codes.manage': 'Manage reason codes',
      'reporting.modify': 'Modify reports',
      'reporting.read.group.custom_payment': 'Group reports by custom payment type',
      'reporting.read.group.customer': 'Group reports by customer',
      'reporting.read.group.date': 'Group reports by date',
      'reporting.read.group.gift_card': 'Group reports by gift card payments',
      'reporting.read.group.inventory_adjustment': 'Group reports by inventory adjustment reason',
      'reporting.read.group.inventory_transfer': 'Group reports by inventory transfer',
      'reporting.read.group.item': 'Group reports by item',
      'reporting.read.group.location': 'Group reports by location',
      'reporting.read.group.payment': 'Group reports by payment type',
      'reporting.read.group.promotion_name': 'Group reports by promotion name',
      'reporting.read.group.purchasing': 'Group reports by purchase order',
      'reporting.read.group.sales_transaction': 'Group reports by sales transaction',
      'reporting.read.group.tax_rule': 'Group reports by tax rule',
      'reporting.read.group.time': 'Group reports by time',
      'reporting.read.group.vendor': 'Group reports by vendor',
      'reporting.read.group': 'Group reports',
      'reporting.read.metric.beginning_gift_card': 'View beginning gift card balances',
      'reporting.read.metric.beginning_inventory': 'View beginning inventory values',
      'reporting.read.metric.current_inventory': 'View current inventory values',
      'reporting.read.metric.ending_gift_card': 'View ending gift card balances',
      'reporting.read.metric.ending_inventory': 'View ending inventory values',
      'reporting.read.metric.gift_card.expire': 'View gift card expirations',
      'reporting.read.metric.inventory_adjustment': 'View inventory adjustment metrics',
      'reporting.read.metric.inventory_transfer': 'View transfer metrics',
      'reporting.read.metric.location_sales_gift_cards': 'View location sales gift cards issued metrics',
      'reporting.read.metric.location_sales': 'View location sales metrics',
      'reporting.read.metric.payment': 'View payment type metrics',
      'reporting.read.metric.purchasing': 'View purchasing metrics',
      'reporting.read.metric.sales_tax': 'View sales tax metrics',
      'reporting.read.metric.shipping': 'View shipping metrics',
      'reporting.read.metric.source_sales_gift_cards': 'View source sales gift cards issued metrics',
      'reporting.read.metric.source_sales': 'View source sales metrics',
      'reporting.read.metric': 'Group by metric',
      'reporting.read': 'View reporting',
      'reporting.sales.read': 'Read sales dashboard reports',
      'reporting.saved_reports.manage': 'Manage Saved Reports',
      'reporting.saved_reports.read': 'View Saved Reports',
      'role.manage': 'Manage roles',
      'sales.coupons.manage': 'Manage coupons',
      'sales.coupons.read': 'View and redeem coupons',
      'sales.daily_summary.read': 'View Daily Summary',
      'sales.invoice.manage': 'Create and fulfill invoices from sales orders',
      'sales.order.adjust_item_price': 'Adjust item prices on a sales order',
      'sales.order.distribute': 'Distribute sales orders',
      'sales.order.edit': 'Create and edit sales orders',
      'sales.order.manage': 'Manage sales orders',
      'sales.order.view': 'View sales orders',
      'sales.pos.adjust_tax_amount': 'Adjust tax amount in the POS',
      'sales.promotions.manage': 'Manage promotions',
      'sales.tax.manage': 'Manage sales tax',
      'sales.ticket.manage': 'Manage POS tickets',
      'sales.transaction.adjust_item_price': 'Adjust item prices in the POS',
      'sales_plans.manage': 'Manage sales plans',
      'setting.manage': 'Manage general settings',
      'shipping_method.manage': 'Manage shipping methods',
      'station.manage': 'Manage stations',
      'user.manage': 'Manage users',
      'webhooks.manage': 'Manage Webhooks'
  end
end

puts SR.to_yaml
