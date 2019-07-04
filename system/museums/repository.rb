require 'mongo'
require_relative '../commons/connection'

module Museums
  class Repository
    @content = []

    class << self

      def connection
          Database::Connection.get_connection
      end

      def choose_action(museum_data)
        id = museum_data['id']
        if (id)
          museum = update(museum_data)
        else
          museum = store(museum_data)
        end
        museum
      end

      def translation_choose_action(data_translation, museum_id)
        data_translation.map! do |data|
          id = data['id']
          if (id)
            update_translation(data)
          else
            store_translation(data, museum_id)
          end
        end
        data_translation
      end

      def retrieve(id)
          data = connection.museums.find({ id: id }).first
          museum = Museums::Museum.from_bson(data, data['id'])
          connection.close
          museum
      end

      def retrieve_translated(id, iso_code)
        data = connection.museums.find({id: id}).first
        museum = Museums::Museum.from_bson(data, data['id']).serialize
        museum_translation = traslation(id, iso_code)
        museum[:info][:description] = set_translation(museum_translation) unless museum_translation.nil?
        museum
      end

      def retrieve_translations(museum_id)
        museum_translations = connection.museum_translations.find({museum_id: museum_id})

        translations =  []
        museum_translations.map do |translation|
          translations.push(Museums::Translation.from_bson(translation, museum_id, translation['id']).serialize)
        end
        translations
      end
      
      
      def flush
        connection.museums.delete_many
      end

      def delete(id)
        museum_data = retrieve(id)
        document = museum_data.serialize
        
        connection.exhibitions.delete_many({museum_id: id})
        connection.museums.delete_one({ id: document[:id] })
      end


      def all(iso_code)
        museums_data = connection.museums.find()
        museums_data.map { |data| Museums::Museum.from_bson(data, data['id']).serialize }
        museums_data.map do |museum|
          museum_translation = traslation(museum[:id], iso_code)
          museum[:info][:description] = set_translation(museum_translation) unless museum_translation.nil?
          museum
        end
      end

      private

      def store(museum_data)
        museum = Museums::Museum.new(museum_data)
        connection.museums.insert_one(museum.serialize)
        connection.close
        museum
      end

      def store_translation(data, museum_id)
        translation_museum = Museums::Translation.new(data, museum_id).serialize
        connection.museum_translations.insert_one(translation_museum)
        translation_museum
        
      end

      def update_translation(translation)
        updated_translation = connection.museum_translations.find_one_and_update({ id: translation['id'] }, { "$set" => translation }, {:return_document => :after })
        Museums::Translation.from_bson(updated_translation, updated_translation['museum_id'], updated_translation['id']).serialize
      end

      
      def update(museum_data)
        museum = Museums::Museum.new(museum_data, museum_data['id'])
        document = museum.serialize
        updated_museum_data = connection.museums.find_one_and_update({ id: document[:id] }, document, {:return_document => :after })
        Museums::Museum.from_bson(updated_museum_data, updated_museum_data['id'])
      end

      def traslation(id, iso_code)
        museum = connection.museum_translations.find({museum_id: id, iso_code: iso_code}).first
        if museum == nil
          iso_code = 'es'
          museum = connection.museum_translations.find({museum_id: id, iso_code: iso_code}).first
        end
        museum
      end

      def set_translation(museum_translation)
        translated_museum = Museums::Translation.from_bson(museum_translation, museum_translation['museum_id'], museum_translation['id']).serialize
        translated_museum[:description]
      end

    end
  end
end
