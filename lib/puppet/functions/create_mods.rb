# This is an autogenerated function, ported from the original legacy version.
# It /should work/ as is, but will not have all the benefits of the modern
# function API. You should see the function docs to learn how to add function
# signatures for type safety and to document this function using puppet-strings.
#
# https://puppet.com/docs/puppet/latest/custom_functions_ruby.html
#
# ---- original file header ----

# ---- original file header ----
#
# @summary
#   
#
#
#
#
Puppet::Functions.create_function(:'create_mods') do
  # @param args
  #   The original array of arguments. Port this to individually managed params
  #   to get the full benefit of the modern function API.
  #
  # @return [Data type]
  #   Describe what the function returns here
  #
  dispatch :default_impl do
    # Call the method named 'default_impl' when this is matched
    # Port this to match individual params for better type safety
    repeated_param 'Any', :args
  end


  def default_impl(*args)
    
  raise ArgumentError, ("create_mods(): wrong number of arguments(#{args.length}; must be 3)") if args.length != 3

  ## What we get
  #
  #  name: name of the vhost in question
  #  mods:
  #   'mod_type' => {mod_parameters}
  #
  #  defaults: parameters copied from vhost definition (ip, port, vhost)
  #
  ## what we need:
  #
  # for each mod defined:
  #
  #   type:       the type of the mod we want
  #   resource:
  #   <name_mod> => {
  #     parameters....
  #   }
  #

  Puppet::Parser::Functions.autoloader.load(:create_resources) unless Puppet::Parser::Functions.autoloader.loaded?(:create_resources)

  name = args[0].downcase
  mods = args[1]
  defaults = args[2]

  raise ArgumentError, ("create_mods(): the second argument should be a hash (#{mods.class} must be Hash)") unless mods.is_a?(Hash)
  raise ArgumentError, ("create_mods(): the third argument should be a hash (#{defaults.class} must be Hash)") unless defaults.is_a?(Hash)

  order_index = 1000
  mods.keys.sort.each do |type|
    mod = mods[type]
    order_index += 1

    defmerge = defaults.dup
    if type =~ /::/
      deftype = type
      type = type.gsub(/::/, '_')
    else
      deftype = "apache::vhost::mod::#{type}"
    end
    if mod.is_a?(Array)
      ### We will need to do some magic on the naming here, appending an index or sth.
      index = 0
      mod.each do |xmod|
        params = defmerge.merge(xmod)
        params['order'] = order_index unless params['order']
        params['_header'] = (index == 0)
        function_create_resources([deftype, {"#{name}_mod_#{type}_#{index}" => params }])
        order_index += 1
        index += 1
      end
    else
      params = defmerge.merge(mod)
      params['order'] = order_index unless params['order']
      params['_header'] = true
      function_create_resources([deftype, { "#{name}_mod_#{type}" => params }])
    end

  end


  end
end