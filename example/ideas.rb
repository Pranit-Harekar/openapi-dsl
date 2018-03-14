# Based on https://github.com/burabure/springboard-retail/blob/packages/api-v2/specification/resources/Users.yaml

resource :user do
  prop :first_name, string
  prop :last_name # or leave string off and let the type be string by default

  # or
  # props :first_name, :last_name
end

# Based on https://github.com/burabure/springboard-retail/blob/packages/api-v2/specification/resources/Stations.yaml

resource :station do
  prop :name
  prop :active, bool
end

# Based on https://github.com/burabure/springboard-retail/blob/packages/api-v2/specification/resources/Customers.yaml

resource :customer do
  props :first_name, :last_name
end

# Based on https://github.com/burabure/springboard-retail/blob/packages/api-v2/specification/resources/Items.yaml

resource :item do
  prop :description
  prop :created_at, datetime
  prop :updated_at, datetime
end

# Based on https://github.com/burabure/springboard-retail/blob/packages/api-v2/specification/resources/SalesOrderLines.yaml

resource :sales_order_line do
  prop :qty, number
  prop :unit_cost, number
  prop :created_at, datetime
  prop :updated_at, datetime

  related_to :item

  collection_methods :get
end

# Based on https://github.com/burabure/springboard-retail/blob/packages/api-v2/specification/resources/SalesOrders.yaml

resource :sales_order do
  # How to describe the attributes of the resource?
  prop :status, string { enum %w(pending open canceled closed) }
  prop :recalculate, bool {
    default true
    description "Whether or not the order's taxes and ..."
  }
  prop :created_at, datetime
  prop :updated_at, datetime

  # How to describe the relationships for the resource?
  related_to \
    :customer,
    :station,
    (relationship :created_by_user, :user),
    (relationship :updated_by_user, :user),
    (relationship :lines, array(of: :sales_order_line))

  # Which HTTP methods to generate for the resource?
  collection_methods :get, :post # /sales-orders/
  methods :get, :patch, :delete # /sales-orders/{id}/

  # What about custom methods?
  # ...
end
