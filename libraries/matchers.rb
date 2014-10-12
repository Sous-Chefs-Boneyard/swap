if defined?(ChefSpec)
  ChefSpec.define_matcher :swap_file

  def create_swap_file(path)
    ChefSpec::Matchers::ResourceMatcher.new(:swap_file, :create, path)
  end

  def remove_swap_file(path)
    ChefSpec::Matchers::ResourceMatcher.new(:swap_file, :remove, path)
  end
end
