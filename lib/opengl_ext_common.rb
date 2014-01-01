module OpenGL
  def self.check_extension( ext_name )
    version_number = glGetString(GL_VERSION).to_s.split(/\./)
    if version_number[0].to_i >= 3
      # glGetString(GL_EXTENSIONS) was deprecated in OpenGL 3.0
      # Ref.: http://sourceforge.net/p/glew/bugs/120/
      extensions_count_buf = '    '
      glGetIntegerv( GL_NUM_EXTENSIONS, extensions_count_buf )
      extensions_count = extensions_count_buf.unpack('L')[0]
      extensions_count.times do |i|
        supported_ext_name = glGetStringi( GL_EXTENSIONS, i ).to_s
        return true if ext_name == supported_ext_name
      end
      return false
    else
      ext_strings = glGetString(GL_EXTENSIONS).to_s.split(/ /)
      return ext_strings.include? ext_name
    end
  end

  def self.setup_extension( ext_name )
    if self.check_extension( ext_name )
      define_ext_enum = "define_ext_enum_#{ext_name}".to_sym
      define_ext_command = "define_ext_command_#{ext_name}".to_sym
      self.send( define_ext_enum )
      self.send( define_ext_command )
    end
  end

  def self.setup_extension_all()
    self.methods.each do |method_name|
      if method_name =~ /define_ext_command_(.*)/
        setup_extension( $1 )
      end
    end
  end

end
