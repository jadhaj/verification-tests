lib_path = File.expand_path(File.dirname(File.dirname(__FILE__)))
unless $LOAD_PATH.any? {|p| File.expand_path(p) == lib_path}
  $LOAD_PATH.unshift(lib_path)
end

require 'collections'
require 'common'

module BushSlicer
  class IPI_BM_LIBVIRT
    include Common::Helper
    include CollectionsIncl
    attr_reader :config

    def initialize(**opts)
      @config = conf[:services, opts.delete(:service_name) || :ipi_bm_libvirt]
    end
  end
end
