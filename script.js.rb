include Glimmer

Address = Struct.new(:street, :street2, :city, :state, :zip_code, keyword_init: true) do
  STATES = {...} # contains US States

  def state_code
    STATES.invert[state]
  end

  def state_code=(value)
    self.state = STATES[value]
  end

  def summary
    string_attributes = to_h.except(:billing_and_shipping)
    summary = string_attributes.values.map(&:to_s).reject(&:empty?).join(', ')
    summary += " (Billing & Shipping)" if billing_and_shipping
    summary
  end
end

@address = Address.new(
  street: '123 Main St',
  street2: 'Apartment 3C, 2nd door to the right',
  city: 'San Diego',
  state: 'California',
  zip_code: '91911',
  billing_and_shipping: true,
)

Document.ready? do
  div {
    div(style: 'display: grid; grid-auto-columns: 80px 260px;') { |address_div|
      label('Street: ', for: 'street-field')
      input(id: 'street-field') {
        # Bidirectional Data-Binding with <=> ensures input.value and @address.street
        # automatically stay in sync when either side changes
        value <=> [@address, :street]
      }

      label('Street 2: ', for: 'street2-field')
      textarea(id: 'street2-field') {
        value <=> [@address, :street2]
      }

      label('City: ', for: 'city-field')
      input(id: 'city-field') {
        value <=> [@address, :city]
      }

      label('State: ', for: 'state-field')
      select(id: 'state-field') {
        Address::STATES.each do |state_code, state|
          option(value: state_code) { state }
        end

        value <=> [@address, :state_code]
      }

      label('Zip Code: ', for: 'zip-code-field')
      input(id: 'zip-code-field', type: 'number', min: '0', max: '99999') {
        # Bidirectional Data-Binding with <=> ensures input.value and @address.zip_code
        # automatically stay in sync when either side changes
        # on_write option specifies :to_s method to invoke on value before writing to model attribute
        # to ensure the numeric zip code value is stored as a String
        value <=> [@address, :zip_code,
                   on_write: :to_s,
                  ]
      }

      div(style: 'grid-column: 1 / span 2') {
        input(id: 'billing-and-shipping-field', type: 'checkbox') {
          checked <=> [@address, :billing_and_shipping]
        }
        label(for: 'billing-and-shipping-field') {
          'Use this address for both Billing & Shipping'
        }
      }

      # Programmable CSS using Glimmer DSL for CSS
      style {
        # `r` is an alias for `rule`, generating a CSS rule
        r("#{address_div.selector} *") {
          margin '5px'
        }
        r("#{address_div.selector} input, #{address_div.selector} select") {
          grid_column '2'
        }
      }
    }

    div(style: 'margin: 5px') {
      # Unidirectional Data-Binding is done with <= to ensure @address.summary changes
      # automatically update div.inner_text
      # (computed by changes to address attributes, meaning if street changes,
      # @address.summary is automatically recomputed.)
      inner_text <= [@address, :summary,
                     computed_by: @address.members + ['state_code'],
                    ]
    }
  }
end
