require_relative 'repository'
require_relative 'scene'
require_relative 'room'
require_relative '../exhibitions/service'

module Items
  class Service
    class << self
      def store_scene(scene_data)
        if (scene_data['type'] == 'scene')
          result = Items::Repository.choose_action(scene_data)
          result.serialize
        else
          raise ArgumentError, 'Updating room not allows changing it to scene'
        end
      end

      def store_room(room_data)
        if ((room_data['parent_class'] == 'exhibition') && (room_data['room'] == true) && (room_data['type'] == 'room'))
          result = Items::Repository.choose_action(room_data, 'room')
          result.serialize
        else
          raise ArgumentError, 'Store or update item error'
        end
      end

      def retrieve(id)
        result = Items::Repository.retrieve(id)
        result.serialize
      end

      def retrieve_by_parent(id)
        children = Items::Repository.retrieve_by_parent(id)
        children.map! do |item|
          {
            id: item.id,
            name: item.name,
            type: item.type,
            number: item.number,
            media_file: 'https://s3.amazonaws.com/pruebas-cova/3minutes.mp4',
            description: item.description,
            children: Items::Service.retrieve_by_parent(item.id)
          }
        end
        children_list = sorted_list(children)
        children_list
      end

      def sorted_list(children)
      children.sort_by { |child| child[:number] }
      end

    end
  end
end
