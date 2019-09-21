require "bundler/gem_tasks"
require "rake/testtask"

task default: :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.warning = false
end

# -- TODO: put everything below somewhere better --

# based on ActiveSupport underscore
def underscore(str)
  str.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
end

def arg_name(name)
  # start and stop choosen as they are used for some operations
  case name
  when "begin"
    "start"
  when "end"
    "stop"
  else
    name
  end
end

def read_op_def
  require "tensorflow"

  # TODO pull these into project?
  path = "#{ENV["HOME"]}/forks/tensorflow"
  $:.push(path)
  require "tensorflow/core/framework/op_def_pb"

  buffer = TensorFlow::FFI.TF_GetAllOpList
  encoded = buffer[:data].read_bytes(buffer[:length])

  Tensorflow::OpList.decode(encoded).op.sort_by(&:name)
end

task :generate_ops do
  defs = []
  read_op_def.each do |op|
    input_names = op.input_arg.map { |v| arg_name(v.name) }
    options = op.attr.map { |v| arg_name(v.name) }.reject { |v| v[0] == v[0].upcase }

    if op.name[0] != "_"
      def_name = underscore(op.name).gsub(/2_d/, "2d").gsub(/3_d/, "3d")
      def_options_str = (input_names + options).map { |v| ", #{v}: nil" }.join
      execute_options_str = options.map { |v| ", #{v}: #{v}" }.join
      defs << %!      def #{def_name}(#{def_options_str})
        Utils.execute("#{op.name}", [#{input_names.join(", ")}]#{execute_options_str})
      end!
    end
  end

  contents = %!# Generated by `rake generate_ops`
module TensorFlow
  module RawOps
    class << self
#{defs.join("\n\n")}
    end
  end
end
!
  contents = contents.gsub("()", "").gsub("(, ", "(")
  # puts contents
  File.write("lib/tensorflow/raw_ops.rb", contents)
end

task :seed_ops do
  require "nokogiri"
  require "open-uri"

  cached_path = "/tmp/ops.html"
  unless File.exist?(cached_path)
    url = "https://www.tensorflow.org/versions/r2.0/api_docs/python"
    puts "Downloading #{url}"
    File.write(cached_path, open(url).read)
  end

  ops = []
  doc = Nokogiri::HTML(File.read(cached_path))
  doc.css("a").each do |node|
    text = node.text.strip
    if text.start_with?("tf.") && text == text.downcase && !text.include?(".compat.")
      ops << text
    end
  end

  # op defs
  op_def = read_op_def.map { |op| [underscore(op.name).gsub(/2_d/, "2d").gsub(/3_d/, "3d"), op] }.to_h

  # top level ops
  tf_ops = ops.select { |op| op.count(".") == 1 }.map { |v| v.sub("tf.", "") }

  # determine modules
  modules = ops.select { |op| op.count(".") == 2 }.map { |v| v.split(".")[1] }.uniq

  modules.each do |mod|
    next unless ["audio", "bitwise", "image", "io", "linalg", "strings"].include?(mod)

    mod_ops = ops.select { |op| op.start_with?("tf.#{mod}.") && op.count(".") == 2 }.map { |v| v.sub("tf.#{mod}.", "") }
    mod_class = mod.capitalize

    next if mod_ops.include?("experimental")

    # puts mod
    # p mod_ops

    defs = []
    mod_ops.each do |def_name|
      op = op_def[def_name]

      if !op
        defs << %!      # def #{def_name}
      # end!
      else
        input_names = op.input_arg.map { |v| arg_name(v.name) }
        options = op.attr.map { |v| arg_name(v.name) }.reject { |v| v[0] == v[0].upcase }

        input_names_str = input_names.join(", ")
        def_options_str = options.map { |v| ", #{v}: nil" }.join
        raw_options_str = (input_names + options).map { |v| "#{v}: #{v}" }.join(", ")
        defs << %!      def #{def_name}(#{input_names_str}#{def_options_str})
        RawOps.#{def_name}(#{raw_options_str})
      end!
      end
    end

    contents = %!module TensorFlow
  module #{mod_class}
    class << self
#{defs.join("\n\n")}
    end
  end
end
!
    contents = contents.gsub("()", "").gsub("(, ", "(")
    # puts contents
    File.write("lib/tensorflow/#{mod}.rb", contents)

    delegate_mod_ops = tf_ops & mod_ops
    if delegate_mod_ops.any?
      puts "def_delegators #{mod_class}, #{delegate_mod_ops.map { |v| v.to_sym.inspect }.join(", ")}"
    end
  end
end
