# Module for tax calculation
module TaxCalculator
    def calculate_total(price, tax_rate)
        price.to_f + (price.to_f * (tax_rate.to_f/100.0))
    end
end

# Class to represent an item
class Item 
    attr_accessor :name, :price, :total

    include TaxCalculator

    def initialize(name, price, tax_rate)
        @name = name
        @price = price.to_f
        @total = calculate_total(@price, tax_rate)
    end
end

# Class to represent the shopping cart
class ShoppindCart
    attr_accessor :items, :tax_rate

    def initialize(tax_rate)
        @items = []
        @tax_rate = tax_rate.to_f
    end
    def add_item(name, price)
        item = Item.new(name, price, @tax_rate)
        @items << item 
    end

    def print_bill
        puts "\n--- Shopping Bill ---"
        grand_total = 0.0
        total_tax = 0.0

        @items.each do |item|
            next if item.total.nil?

            tax = item.total - item.price
            puts "#{item.name} -> Base: $#{item.price} | Tax: $#{tax.round(3)} | Total: $#{item.total.round(3)}"
            grand_total += item.total
            total_tax += tax
        end
        puts "----------------------"
        puts "Total Tax Paid: $#{total_tax.round(3)}"
        puts "Grand Total: $#{grand_total.round(3)}"
    end
end

print "Enter the sales tax rate(%) of item: "
tax_rate = gets.to_f
cart = ShoppindCart.new(tax_rate)

loop do 
    print "Enter the name of item (or 'done' to finish): "
    name = gets.chomp.strip.capitalize
    break if name.downcase == "done"

    print "Enter the price of #{name}: "
    price =gets.to_f
    cart.add_item(name, price)
end

cart.print_bill 