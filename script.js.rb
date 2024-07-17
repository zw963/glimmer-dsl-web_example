include Glimmer

Document.ready? do
  div {
    h1('Contact Form')

    form {
      div {
        label('Name: ', for: 'name-field')
        @name_input = input(type: 'text', id: 'name-field', required: true, autofocus: true)
      }

      div {
        label('Email: ', for: 'email-field')
        @email_input = input(type: 'email', id: 'email-field', required: true)
      }

      div {
        input(type: 'submit', value: 'Add Contact') {
          onclick do |event|
            if ([@name_input, @email_input].all? {|input| input.check_validity })
              # re-open table content and add row
              @table.content {
                tr {
                  td { @name_input.value }
                  td { @email_input.value }
                }
              }
              @email_input.value = @name_input.value = ''
              @name_input.focus
            end
          end
        }
      }
    }

    h1('Contacts Table')

    @table = table {
      tr {
        th('Name')
        th('Email')
      }

      tr {
        td('John Doe')
        td('johndoe@example.com')
      }

      tr {
        td('Jane Doe')
        td('janedoe@example.com')
      }
    }

    # CSS Styles
    style {
      # CSS can be included as a String as done below, or as Glimmer DSL for CSS syntax (Ruby code) as done in other samples
      <<~CSS
        input {
          margin: 5px;
        }
        input[type=submit] {
          margin: 5px 0;
        }
        table {
          border:1px solid grey;
          border-spacing: 0;
        }
        table tr td, table tr th {
          padding: 5px;
        }
        table tr:nth-child(even) {
          background: #ccc;
        }
      CSS
    }
  }
end
