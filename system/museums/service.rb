require 'digest/md5'
require_relative 'repository'
require_relative 'museum'
require_relative 'info'
require_relative 'location'
require_relative 'contact'
require_relative 'price'
require_relative 'schedule'
require_relative 'defense'

module Museums
  class Service
    class << self
      def store(museum_data)
        museum = Museums::Repository.store(museum_data)
        museum.serialize
      end

      def retrieve(name)
        museum = Museums::Repository.retrieve(name)
        museum.serialize
      end

      def list
        list = Museums::Repository.all
        list.map { |museum| museum.serialize }
      end
    end
  end
end
