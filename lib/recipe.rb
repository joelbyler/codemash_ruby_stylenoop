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
    !!items.any? {|item|includes_ingredient? item}
  end

  def includes_ingredient?(item)
    !!ingredients.find {|ingredient|ingredient.include? item}
  end

  def ingredients
    @ingredients ||= []
  end
end

class RecipeDefinition
  # def initialize(name)
  #   @name = name
  #   yield self if block_given?
  # end
  def initialize(name,&block)
    @name = name
    instance_eval(&block)
  end

  def ingredients
    @ingredients ||= []
  end
  def ingredient (name)
    ingredients.push name
  end
  def instructions
    @instructions ||= []
  end
  def instruction (step)
    instructions.push step
  end
  def serves (serves)
    @serves = serves
  end
  def servings
    @serves ||= ""
  end
  def recipe
    Recipe.new @name, ingredients, instructions, servings
  end
end

describe Recipe do
  let(:name) { 'Chocolate Chip Cookies' }
  let(:ingredients) { ['Chocolate', 'Chips', 'Cookies', '1 cup white sugar', 'love'] }
  let(:instructions) { ['U HAZ DEM, DONE!'] }
  let(:servings) { '1 Dozen' }

  context "Recipe with three arguments" do

    let(:recipe) { Recipe.new name, ingredients, instructions }

    it "should know its name" do
      recipe.name.should == name
    end
  end
  context "Recipe with four arguments" do
    let(:recipe) { Recipe.new name, ingredients, instructions, servings }

    it "should know its servings" do
      recipe.servings.should == servings
    end
  end
  context "Recipe with named arguments" do
    let(:recipe) { Recipe.new name: name, ingredients: ingredients, instructions: instructions, servings: servings }

    it "should know its servings" do
      recipe.name.should == name
      recipe.ingredients.should == ingredients
      recipe.instructions.should == instructions
      recipe.servings.should == servings
    end
  end

  context "Recipe with special ingredient" do

    let(:recipe) { Recipe.new name: name, ingredients: ingredients, instructions: instructions, servings: servings }
    
    it "Should now when there is an ingredient" do
      recipe.include?('white sugar').should == true
    end
    it "Should now when there isn't an ingredient" do
      recipe.include?('peanuts').should == false
    end
    it "Should be able to check for one of many ingredients" do
      recipe.include?('peanuts', 'white sugar').should == true
    end

  end
end

describe RecipeDefinition do
  let(:name) { 'Chocolate Chip Cookies' }

  context "RecipeDefinition constructor" do
    it "should accept a block" do
      definition = RecipeDefinition.new name do
        ingredient "Foo"
        ingredient "Bar"
        ingredient "Baz"

        instruction "Preheat oven to 350 degrees"
        instruction "Chow down!"

        serves "1 Dozen"
      end
      recipe = definition.recipe
      recipe.name.should == name
      recipe.ingredients.length.should == 3
      recipe.instructions.length.should == 2
      recipe.servings.should == "1 Dozen"
    end
  end

  # context "RecipeDefinition can handle monkey patched quantities" do
  #   it "should accept a block" do
  #     definition = RecipeDefinition.new name do
  #       ingredient "butter", 1.cup, "softened"
  #       ingredient "milk", 3.cups
  #       instruction "Preheat oven to 350 degrees F (175 degrees C)."
  #       serves 4.dozen, "cookies"
  #     end

  #     recipe = definition.recipe
  #     recipe.name.should == name
  #     recipe.ingredients[0].shoud == "1 cup softened butter"
  #     recipe.ingredients[0].shoud == "3 cups milk"
  #     recipe.instructions[0].should == "Preheat oven to 350 degrees F (175 degrees C)."
  #     recipe.servings.should == "4 dozen cookies"
  #   end
  # end


end



