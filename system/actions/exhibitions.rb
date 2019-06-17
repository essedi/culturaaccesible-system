module Actions
  class Exhibition
    class << self
      def retrieve_for_list(exhibition)
        order = Exhibitions::Service.retrieve_object(exhibition[:id]).order
        children = Items::Service.retrieve_by_parent(exhibition[:id], order)
        sorted_children = Exhibitions::Service.sort_list_beacon(children)
        sorted_children.map! do |item|
          begin
            {
              id: item[:id],
              name: item[:name],
              number: item[:number],
              type: item[:type],
              children: item[:children]
            }
          rescue
            next
          end
        end
        sorted_children.reject!{ |child| child == nil }
        { id: exhibition[:id], name: exhibition[:name], creation_date: exhibition[:creation_date], :children => sorted_children }
      end

      def retrieve_all_items( exhibition, iso_code )
        order = Exhibitions::Service.retrieve_object(exhibition[:id]).order
        children = Items::Service.retrieve_by_parent(exhibition[:id], order, iso_code)
        children.map! do | item |
          begin
            {
              id: item[:id],
              name: item[:name] || '',
              author: item[:author] || '',
              date: item[:date] || '',
              beacon: item[:beacon] || '',
              lat: item[:lat] || '',
              lng: item[:lng] || '',
              description: item[:description] || '',
              image: item[:image] || '',
              video: item[:video] || '',
              parent_id: item[:parent_id] || '',
              parent_class: item[:parent_class] || '',
              type: item[:type] || '',
              children: item[:children]
            }
          rescue
            next
          end
        end
        children.reject!{ |child| child == nil }
        Exhibitions::Service.sort_list(children)
      end

      def delete_item(item_id, exhibition_id)
        exhibition = Exhibitions::Service.retrieve_object(exhibition_id)

        order = exhibition.order
        order.delete(item_id)

        children = Items::Service.retrieve_childrens(item_id)

        children.each do |child|
          order.delete(child[:id])

          subchildren = Items::Service.retrieve_childrens(child[:id])
          subchildren.each do |subchild|
            order.delete(subchild[:id])
          end
        end

        Exhibitions::Service.update_exhibition(exhibition)
      end

      def add_museum_info(exhibition)
        museum = Museums::Service.retrieve(exhibition[:museum_id])
        data = {
          id: museum[:id],
          name: museum[:info][:name]
        }
        exhibition[:museum] = data
        exhibition.delete(:museum_id)
        exhibition
      end
    end
  end
end
