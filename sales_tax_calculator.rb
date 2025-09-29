def calculate_total(price, tax_rate)
    tax_amount = price * (tax_rate / 100.0)
    total = price + tax_amount
    return total
end


shopping_cart = []


 loop do 
    print "Enter the name of item(or 'done' to finish): "
    name = gets.chomp.capitalize
    break if name.capitalize == "Done"
    
    print "Enter the price of #{name}: "
    price = gets.to_f

    print "Enter sales tax rate in %: "
    tax_rate = gets.to_f

    total_price = calculate_total(price, tax_rate)
    shopping_cart << { name: name, price: price, total: total_price}
 end

 puts "\n--- Shopping Bill ---"
 grand_total = 0
 shopping_cart.each do |item|
    puts "#{item[:name]} - Base: $#{item[:price]} | After Tax: $#{item[:total].round(3)}"
    grand_total += item[:total]
 end

puts "----------------------"
puts "Grand Total: $#{grand_total.round(2)}"
