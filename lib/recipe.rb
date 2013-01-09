class Recipe
  attr_reader :name, :ingredients, :instructions, :servings

  def initialize(name_or_options, ingredients=nil, instructions=nil, servings=nil)
    params = support_old_arguments(name_or_options, ingredients, instructions, servings)
    initialize_with_hash(params)
  end
  def initialize_with_hash(params)
    @name=params[:name]
    @ingredients=params[:ingredients]
    @instructions=params[:instructions]
    @servings=params[:servings] || nil
  end
  def support_old_arguments(name_or_options, ingredients, instructions, servings)
    return name_or_options if name_or_options.is_a? Hash
    old_params_to_hash name_or_options, ingredients, instructions, servings
  end
  def old_params_to_hash(name, ingredients, instructions, servings)
    {
      :name => name,
      :ingredients => ingredients,
      :instructions => instructions,
      :servings => servings
    }
  end

  def include?(*items)
    !!items.find {|item|includes_ingredient? item}
    # items.find do |item|
    #   return true if includes_ingredient? item
    # end
    # return false
  end

  def includes_ingredient?(item)
    !!ingredients.find {|ingredient|ingredient.include? item}
    # @ingredients.find do |ingredient|
    #   return true if ingredient.include? item
    # end
    # return false
  end

  def ingredients
    @ingredients ||= []
  end
end

cookies = Recipe.new 'Chocolate Chip Cookies', ['1 cup white sugar', 'semi-sweet chocolate chips', 'love'] , ['U HAZ DEM, DONE!'], '1 dozen'
puts cookies.include? 'white sugar'
puts cookies.include? 'peanuts'
puts cookies.include? 'peanuts', 'white sugar'


describe Recipe do
  let(:name) { 'Chocolate Chip Cookies' }
  let(:ingredients) { ['Chocolate', 'Chips', 'Cookies'] }
  let(:instructions) { ['U HAZ DEM, DONE!'] }
  
  subject { Recipe.new name, ingredients, instructions }

  its(:name) { should == name }
  its(:ingredients) { should == ingredients }
  its(:instructions) { should == instructions }

end

describe Recipe do
  let(:name) { 'Chocolate Chip Cookies' }
  let(:ingredients) { ['Chocolate', 'Chips', 'Cookies'] }
  let(:instructions) { ['U HAZ DEM, DONE!'] }
  let(:servings) { '1 Dozen' }

  subject { Recipe.new ( { :name => name, :ingredients => ingredients, :instructions => instructions, :servings => servings } ) }

  its(:servings) { should == servings }

end

describe Recipe do
  let(:name) { 'Chocolate Chip Cookies' }
  let(:ingredients) { ['Chocolate', 'Chips', 'Cookies'] }
  let(:instructions) { ['U HAZ DEM, DONE!'] }
  let(:servings) { '1 Dozen' }
  
  subject { Recipe.new name: name, ingredients: ingredients, instructions: instructions, servings: servings }

  its(:name) { should == name }
  its(:ingredients) { should == ingredients }
  its(:instructions) { should == instructions }
  its(:servings) { should == servings }

end



describe Recipe do
  let(:name) { 'Chocolate Chip Cookies' }
  let(:ingredients) { ['Chocolate', 'Chips', 'Cookies'] }
  let(:instructions) { ['U HAZ DEM, DONE!'] }
  let(:servings) { '1 Dozen' }

  context "Recipe with three arguments" do

    let(:recipe) { Recipe.new name, ingredients, instructions }

    it "should know its name" do
      recipe.name.should == name
    end
  end
  context "Recipe with three arguments" do
  end
end

