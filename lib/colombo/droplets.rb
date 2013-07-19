# encoding: utf-8

require "colombo/droplet"

module Colombo
  class Droplets < Container

    def initialize(client)
      @client = client
      @client.request(:get, '/droplets/', {}) do |response|
         response['droplets'].each do |droplet|
            self << Droplet.new(@client, droplet)
         end
      end
    end

    def create(options={})

     [:name,:size_id, :image_id,:region_id].each do |key|
        raise "Required `#{key}` attribute" if not options.include?( key )
      end

      if options[:ssh_key_ids]
        options[:ssh_key_ids] = options[:ssh_key_ids].join(',')
      end
      
      droplet = nil
      @client.request(:get, '/droplets/new', options) do |response|
        droplet = Droplet.new(@client, response['droplet'])
      end
      droplet
    end

  end
end
