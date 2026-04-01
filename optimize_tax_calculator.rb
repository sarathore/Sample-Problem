# Module for tax calculation
module TaxCalculator
  def calculate_total(price, tax_rate)
    price.to_f + (price.to_f * (tax_rate.to_f / 100.0))
  end
end

# Class for each item
class Item
  attr_accessor :name, :price, :tax_rate, :total

  include TaxCalculator

  def initialize(name, price, tax_rate)
    @name = name.capitalize
    @price = price.to_f
    @tax_rate = tax_rate.to_f
    @total = calculate_total(@price, @tax_rate)
  end
end

# Class for shopping cart
class ShoppingCart
  attr_accessor :items

  def initialize
    @items = []
  end

  def add_item(item)
    @items << item
  end

  def print_bill
    puts "\n--- Shopping Bill ---"
    grand_total = 0.0
    total_tax = 0.0

    @items.each do |item|
      tax = item.total - item.price
      puts "#{item.name} -> Base: $#{item.price} | Tax: $#{tax.round(2)} | Total: $#{item.total.round(2)} | Tax Rate: #{item.tax_rate}%"
      grand_total += item.total
      total_tax += tax
    end

    puts "----------------------"
    puts "Total Tax Paid: $#{total_tax.round(2)}"
    puts "Grand Total: $#{grand_total.round(2)}"
  end
end

# Helper: numeric input
def ask_numeric(prompt, default=nil)
  loop do
    print prompt
    input = gets.strip
    return default.to_f if input.empty? && default   # use default if user presses enter
    return input.to_f if input.match?(/^\d+(\.\d+)?$/) && input.to_f >= 0
    puts "Please enter a valid positive number."
  end
end

# Helper: validate product name
def ask_name(prompt, dictionary)
  loop do
    print prompt
    input = gets.strip
    return nil if input.downcase == "done"
    if input.empty?
      puts "Product name can't be empty."
      next
    end
    input_normalized = input.capitalize

    # Check for close match in dictionary
    suggestion = dictionary.keys.find { |word| word.downcase.start_with?(input.downcase[0..2]) }
    if suggestion && suggestion != input_normalized
      puts "Did you mean '#{suggestion}'? (y/n)"
      answer = gets.strip.downcase
      return suggestion if answer == "y"
    end

    return input_normalized
  end
end

# --- Main Program ---
PRODUCT_DETAILS = {
  "Shoes" => { price: 2000, tax_rate: 10 },
  "Bag" => { price: 1500, tax_rate: 5 },
  "Watch" => { price: 5000, tax_rate: 12 }
}

cart = ShoppingCart.new

loop do
  name = ask_name("Enter item name (or 'done' to finish): ", PRODUCT_DETAILS)
  break if name.nil?

  if PRODUCT_DETAILS.key?(name)
    details = PRODUCT_DETAILS[name]
    puts "Auto-suggested Price: $#{details[:price]}, Tax Rate: #{details[:tax_rate]}%"
    price = ask_numeric("Enter price (or press Enter to accept suggested $#{details[:price]}): ", details[:price])
    tax_rate = ask_numeric("Enter tax rate (or press Enter to accept suggested #{details[:tax_rate]}%): ", details[:tax_rate])
  else
    price = ask_numeric("Enter price of #{name}: ")
    tax_rate = ask_numeric("Enter tax rate (%) for #{name}: ")
    PRODUCT_DETAILS[name] = { price: price, tax_rate: tax_rate }  # add new product
  end

  item = Item.new(name, price, tax_rate)
  cart.add_item(item)
end

cart.print_bill
