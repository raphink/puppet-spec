require 'fileutils'

module Puppetx::Policy::Spec
  def self.copy_spec_files(classes, spec_dir)
    classes.each do |klass|
      module_name = klass.split('::').first
      subclass = klass.split('::')[1..-1].join('/')
      Puppet[:modulepath].split(':').each do |path|
        src_spec_dir = path + '/' + module_name + '/files/serverspec/' + subclass
        if File.directory? src_spec_dir
          Dir[src_spec_dir + '/*'].each do |filepath|
            filename = filepath.split('/').last
            FileUtils.cp(filepath, spec_dir+'/'+klass.gsub('::','_')+'_'+filename)
          end
        end
      end
    end
  end
end
