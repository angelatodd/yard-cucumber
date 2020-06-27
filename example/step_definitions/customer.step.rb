step "that Customer :customer_number is a valid customer" do
end

step "that the product, named ':product', is a valid product" do
end

step "the customer has purchased the product" do
  skip # pending step
end

step "I expect the customer to be a member of the ':product_type' group" do
end

placeholder :product_type do
  match %r{(Product A|Product B|Product C)}
end
