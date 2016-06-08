require 'pp'
require 'tempfile'
require 'date'
#
# Put your custom functions in this class in order to keep the files under lib untainted
#
# This class has access to all of the private variables in deploy/lib/server_config.rb
#
# any public method you create here can be called from the command line. See
# the examples below for more information.
#
class ServerConfig

  #
  # You can easily "override" existing methods with your own implementations.
  # In ruby this is called monkey patching
  #
  # first you would rename the original method
  # alias_method :original_deploy_modules, :deploy_modules

  # then you would define your new method
  # def deploy_modules
  #   # do your stuff here
  #   # ...

  #   # you can optionally call the original
  #   original_deploy_modules
  # end

  #
  # you can define your own methods and call them from the command line
  # just like other roxy commands
  # ml local my_custom_method
  #
  # def my_custom_method()
  #   # since we are monkey patching we have access to the private methods
  #   # in ServerConfig
  #   @logger.info(@properties["ml.content-db"])
  # end

  #
  # to create a method that doesn't require an environment (local, prod, etc)
  # you woudl define a class method
  # ml my_static_method
  #
  # def self.my_static_method()
  #   # This method is static and thus cannot access private variables
  #   # but it can be called without an environment
  # end

  def dep
    deploy_src
  end

  def deploy_users
    log_header "Deploying Users"
    ARGV.push('import')
    ARGV.push('-input_file_path')
    ARGV.push('data/users')
    ARGV.push('-document_type')
    ARGV.push('text')
    ARGV.push('-output_uri_replace')
    ARGV.push(%Q{"#{ServerConfig.expand_path("#{@@path}/../data/")},''"})
    ARGV.push('-transform_module')
    ARGV.push('/transform/from-json.xqy')
    ARGV.push('-transform_namespace')
    ARGV.push('"http://marklogic.com/transform/from-json"')
    ARGV.push('-transform_function')
    ARGV.push('transform')
    ARGV.push('-output_collections')
    ARGV.push('user')
    ARGV.push('-output_permissions')
    logger.info %Q{"#{ServerConfig.expand_path("#{@@path}/../data")},''"}
    role_name = @properties['ml.app-name'] + "-role"
    ARGV.push("#{role_name},read,#{role_name},update,#{role_name},insert,#{role_name},execute")
    mlcp
  end


  def deploy_content
    # eat the argv to prevent errors
    small

    deploy_users
    # deploy_codes
    # deploy_spl_to_ndc_mapping unless small
    # deploy_rxnorm
    # deploy_atc
    # deploy_nddf
    # deploy_icd9_to_snomed
    # deploy_geonames_geo

    # deploy_provider_charge_data
    # deploy_npi

    # deploy_spl
    # deploy_claims
    # deploy_patient_records

    # deploy_meddra
    # deploy_literature
    # deploy_news
    # deploy_faers
    # deploy_diabetes
    # deploy_prescriber_charge
  end


  private

  def log_header(txt)
    logger.info(%Q{########################\n# #{txt}\n########################})
  end

  def small
    @small = @small || find_arg(['--small']) != nil
  end
end
