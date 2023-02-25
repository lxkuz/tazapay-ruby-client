# Tazapay

Tazapay API ruby client


## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add tazapay

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install tazapay

## Usage

### Setup Tazapay client


```ruby
require "tazapay"

Tazapay.configure do |config|
  config.base_url =  "<SANDBOX_API_URL / PRODUCTION_API_URL>"
  config.access_key = "<API_Key>"
  config.secret_key = "<API_Secret>"
end

```

### Checkout

```ruby

tazapay_checkout = Tazapay::Checkout.new

# Create payment transaction
tx_number = tazapay_checkout.pay(data)["data"]["txn_no"]

# Check transaction status
data = tazapay_checkout.get_status(tx_number)

```

### User

```ruby

tazapay_user = Tazapay::User.new

data = {
  email: "sometest+12@mail.io",
  country: "SG",
  ind_bus_type: "Business",
  business_name: "TEST SANDBOX",
  contact_code: "+65",
  contact_number: "9999999999",
  partners_customer_id: "test-123"
}

# Create user
user_id = tazapay_user.create(data)["data"]["account_id"]

# Update user
tazapay_user.update(user_id, new_data)

# Find user by ID
tazapay_user.find(user_id)

# Find user by Email
tazapay_user.find(email)

```

See more details in tests

### Bank

```ruby

tazapay_bank = Tazapay::Bank.new

data = {
  email: "sometest+12@mail.io",
  country: "SG",
  ind_bus_type: "Business",
  business_name: "TEST SANDBOX",
  contact_code: "+65",
  contact_number: "9999999999",
  partners_customer_id: "test-123"
}

# Add bank account
bank_id = tazapay_bank.add(
  account_id: user_id, bank_data: new_data
)['data']['bank_id']

# List user banks
tazapay_bank.list(user_id)

# Make bank account primary
tazapay_bank.make_primary(bank_id: bank_id, account_id: user_id)

```

See more details in tests


### Metadata

```ruby

tazapay_metadata = Tazapay::Metadata.new

# See https://docs.tazapay.com/reference/country-configuration-api
tazapay_metadata.country_config(country)

# See https://docs.tazapay.com/reference/invoice-currency-api
tazapay_metadata.invoice_currency(buyer_country:, seller_country:)

# See https://docs.tazapay.com/reference/collection-methods-api
tazapay_metadata.collection_methods(buyer_country:, seller_country:, invoice_currency:, amount:)

# See https://docs.tazapay.com/reference/disburse-methods-api
tazapay_metadata.disbursement_methods(buyer_country:, seller_country:, invoice_currency:, amount:)

# Doc upload URL
tazapay_metadata.doc_upload_url

# KYB Doc
tazapay_metadata.kyb_doc(country)

# See https://docs.tazapay.com/reference/get-milestone-schemes
tazapay_metadata.milestone_scheme

```

See more details in tests


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lxkuz/tazapay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/tazapay/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Tazapay project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/tazapay/blob/main/CODE_OF_CONDUCT.md).
