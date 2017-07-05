module Page
  class Exhibitions
    include Capybara::DSL

    def initialize
      url = '/home'
      visit(url)
      validate!
    end

    def fill(field, content)
      fill_in(field, with: content, wait: 2)
    end

    def form_submit_deactivated?
      button = find('.submit')
      button.disabled?
    end

    def show
      has_css?('#action', wait: 2)
      find('#action').click
    end

    def first_exhibition_name
      has_css?('.list-item', wait: 2)
      first('.exhibition-name').text
    end

    def save
      has_css?('.submit.cuac-exhibition-form', wait: 4)
      find('.submit.cuac-exhibition-form').click
    end

    def click_edit
      has_css?('.edit-button', wait: 4)
      find('.edit-button').click
    end

    def view_visible?
      view = find('.view', visible: false)
      view.visible?
    end

    def form_visible?
      form = find('.form', visible: false)
      form.visible?
    end

    def exhibition_list?
      has_css?('.list-item.cuac-exhibition-detail', wait: 2)
    end

    def list_has_items?
      has_css?('.exhibition-item', wait: 2)
    end

    def list_has_rooms?
      has_css?('.exhibition-room', wait: 2)
    end

    def item_and_room_have_plus_button?
      has_css?('.exhibition-room .plus-button', wait: 2) && has_css?('.exhibition-item .plus-button', wait: 2)
    end

    def form_submit_deactivated?
      has_css?('.submit[disabled].cuac-exhibition-form')
    end

    def other_name?
      has_css?('.exhibition-name', text: 'some other name', wait: 2)
    end

    def click_plus_button
      has_css?('.plus-button', wait: 4)
      first('.plus-button').click
    end

    def title(name)
      page.has_title?(name)
    end

    def has_edit_button?
      has_css?('.edit-button')
    end

    private

    def validate!
      assert_selector('#formulary', visible: false)
      assert_selector('#action')
      assert_selector('#listing', visible: false)
      assert_selector('#result', visible: false)
      assert_selector("input[name='name']", visible: false)
      assert_selector("input[name='location']", visible: false)
    end
  end
end
