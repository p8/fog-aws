require 'fog/core/model'
require 'fog/vcloudng/models/compute/vm_customization'


module Fog
  module Compute
    class Vcloudng

      class Vm < Fog::Model
        identity  :id

        attribute :vapp_id                  
        attribute :name
        attribute :type
        attribute :href
        attribute :status 
        attribute :operating_system
        attribute :ip_address
        attribute :cpu, :type => :integer
        attribute :memory
        attribute :hard_disks, :aliases => 'disks'
        
        #def links
        #  attributes["links"]
        #end
        #
        #def generate_methods
        #  attributes["links"].each do |link|
        #    next unless link[:method_name]
        #    self.class.instance_eval do 
        #      define_method(link[:method_name]) do
        #        puts link[:href]
        #        service.get_href(link[:href])
        #      end
        #    end
        #  end
        #end
        
        def power_on
          response = service.post_vm_poweron(id)
          service.process_task(response)
        end
        
        def tags
          requires :id
          service.tags(:vm_id => id)
        end
            
        def customization
          data = service.get_vm_customization(id).body
          service.vm_customizations.new(data)
        end
        
        def network
          data = service.get_vm_network(id).body
          service.vm_networks.new(data)
        end
        
        def disks
          requires :id
          service.disks(:vm_id => id)
        end
        
        #def reload
        #  service.vms(:vapp_id => vapp_id).get(id)
        #end
        
        def memory=(new_memory)
          has_changed = ( memory != new_memory.to_i )
          not_first_set = !memory.nil?
          attributes[:memory] = new_memory.to_i
          if not_first_set && has_changed
            response = service.put_vm_memory(id, memory)
            service.process_task(response)
          end
        end
        
        def cpu=(new_cpu)
          has_changed = ( cpu != new_cpu.to_i )
          not_first_set = !cpu.nil?
          attributes[:cpu] = new_cpu.to_i
          if not_first_set && has_changed
            response = service.put_vm_cpu(id, cpu)
            service.process_task(response)
          end
        end

        
      end
    end
  end
end