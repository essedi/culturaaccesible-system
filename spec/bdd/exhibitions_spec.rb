require 'spec_helper_bdd'
require_relative 'test_support/exhibitions'
require_relative 'test_support/museum'
require_relative 'test_support/fixture_exhibitions'
require_relative 'test_support/fixture_museum'
require_relative 'test_support/exhibition_info'

feature 'item list' do
  before(:all) do
    Fixture::XExhibitions.pristine.complete_scenario
  end

  xscenario 'shows each room with + button' do
    current = Page::Exhibitions.new
    current.toggle_list

    expect(current.room_have_plus_button?).to be true
  end

  scenario 'shows each sub-scene without + button' do
    current = Page::Exhibitions.new
    current.toggle_list

    expect(current.subscene_has_plus_button?).to be false
  end

  scenario 'shows list sorted by creation date'  do
    current = Page::Exhibitions.new

    expect(current.second_exhibition_shown?).to be true
  end

  scenario 'links to create item page' do
    current = Page::Exhibitions.new

    current.click_plus_button

    expect(current.title(Fixture::XExhibitions::REDIRECTED_PAGE_TITLE)).to be true
  end

  scenario 'shows sidebar in all exhibitions pages' do
    current = Page::Exhibitions.new
    expect(current.has_sidebar?).to be true

    current.go_to_exhibition_info(Fixture::XExhibitions::NAME)

    expect(current.has_sidebar?).to be true
  end
end

feature 'Sidebar' do
  before(:all) do
    Fixture::XMuseum.complete_scenario
  end

  scenario 'shows a list of museums' do
    current = Page::Exhibitions.new

    expect(current.sidebar_has_museums?).to be true
  end

  scenario 'museum name links to museum detail' do
    current = Page::Exhibitions.new

    current.go_to_museum_info

    expect(current.title(Fixture::XMuseum::PAGE_TITLE)).to be true
  end

  scenario 'has new museum button' do
    current = Page::Exhibitions.new

    expect(current.has_new_museum_button?).to be true
  end

  scenario 'is in museum page' do
    current = Page::Museum.new

    expect(current.has_sidebar?).to be true
  end
end

feature 'create exhibitions' do
  before(:all) do
    Fixture::XExhibitions.pristine
  end

  scenario 'displays languages toggle buttons' do
    current = Page::Exhibitions.new

    expect(current.has_language_toggle_button?('en')).to be true
    expect(current.has_language_toggle_button?('cat')).to be true
  end

  context 'exhibition created' do
    before(:all) do
      Fixture::XExhibitions.pristine.complete_scenario
    end

    let(:current) { Page::Exhibitions.new.create_one }

    scenario 'displays editable info' do
      expect(current.view_visible?).to be true
      expect(current.has_edit_button?).to be true
    end

    scenario 'displays form when edit' do
      current.click_edit
      expect(current.view_visible?).to be false
      expect(current.form_visible?).to be true
    end

    scenario 'added link shows an image' do
      current.go_to_exhibition_info(Fixture::XExhibitions::SECOND_EXHIBITION)
      Page::ExhibitionInfo.new

      expect(page).to have_xpath("//img[contains(@src,'https://s3.amazonaws.com/pruebas-cova/girasoles.jpg')]" )
    end
  end
end

feature 'Click plus button from sidebar to' do
  before(:all) do
    Fixture::XExhibitions.pristine
  end

  scenario 'new exhibition' do
    current = Page::Exhibitions.new
    current.click_add_exhibition
    expect(current.has_css?('.cuac-exhibition-form', wait: 2)).to be true
  end
end

feature 'updates' do
  scenario 'exhibition info' do
    Fixture::XMuseum.pristine.complete_scenario
    current = Page::Exhibitions.new
    current.create_one
    current.edit_exhibition

    current.save

    expect(current.other_name?).to be true
  end

  scenario 'shows museum name saved in view' do
    current = Fixture::Exhibitions.pristine.exhibition_saved

    expect(current.view_has_museum?(Fixture::Museum::OTHER_NAME)).to be true
  end

  scenario 'shows museum name saved in edit view' do
    Fixture::XExhibitions.pristine.complete_scenario

    current = Page::Exhibitions.new
    current.go_to_exhibition_info(Fixture::XExhibitions::NAME)

    expect(current.view_has_museum?(Fixture::XMuseum::FIRST_MUSEUM)).to be true
  end
end

feature 'deletes' do
  scenario 'doesnt show exhibition name in sidebar when is deleted' do
    Fixture::XExhibitions.pristine.complete_scenario
    current = Page::Exhibitions.new

    current.delete_exhibition(Fixture::XExhibitions::SECOND_EXHIBITION)

    expect(current.content?(Fixture::XExhibitions::NAME)).to be true
    expect(current.content?(Fixture::XExhibitions::SECOND_EXHIBITION)).to be false
  end
end
