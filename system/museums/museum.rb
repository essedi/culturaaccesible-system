module Museums
  class Museum
    attr_reader :name, :id


    DEFAULT_ISO_CODE = ['es']

    def initialize(data, id=nil)
      @creation_date = Time.now.utc
      @info = Info.new(data['info'] || {})
      @location = Location.new(data['location'] || {})
      @contact = Contact.new(data['contact'] || {})
      @price = Price.new(data['price'] || {})
      @schedule = Schedule.new(data['schedule'] || {})
      @iso_codes = data['iso_codes'] || DEFAULT_ISO_CODE
      @id = id || generate_id
    end

    def serialize
      {
        creation_date: @creation_date,
        info: info.serialize,
        id: @id,
        location: location.serialize,
        contact: contact.serialize,
        price: price.serialize,
        schedule: schedule.serialize,
        iso_codes: @iso_codes
      }
    end
    
 

    def self.from_bson(bson, id)
      Museums::Museum.new(bson, id)
    end

    def info
      @info
    end

    def id
      @id
    end

    private

    def generate_id
      Digest::MD5.hexdigest(@creation_date.to_s + @creation_date.nsec.to_s + @info.name)
    end

    def location
      @location
    end

    def contact
      @contact
    end

    def price
      @price
    end

    def schedule
      @schedule
    end
  end
end
