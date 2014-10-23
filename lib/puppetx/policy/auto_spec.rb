module Puppetx::Policy::AutoSpec
  def self.newspec(type, &block)
    @auto_specs ||= []
    @auto_specs << { :type => type, :block => block }
  end

  def self.gen_auto_spec_files(resources, spec_dir)
    @auto_specs.each do |spec|
      spec_content = "describe '#{spec[:type]} resources' do\n"
      spec_content += resources.map do |r|
        next unless r.type == spec[:type]
        spec[:block].call(r.to_hash)
      end.compact.join("\n")
      spec_content += "end\n"

      file_name = spec[:type].downcase.gsub(':', '_') + '_spec.rb'
      file = File.join(spec_dir, file_name)

      File.open(file, 'w') do |f|
        f.write(spec_content)
      end
    end
  end
end
