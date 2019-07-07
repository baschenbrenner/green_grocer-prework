require "pry"
def consolidate_cart(cart)
  new_cart = {}
  list_of_items = cart.map {|item| item.keys[0]}


  cart.each do |item|

    item.values[0][:count] = list_of_items.select{|name| item.keys[0] == name}.length
    updated_item = item
    if !new_cart[item.keys[0]]
    new_cart[item.keys[0]] = item.values[0]
    end
  end
  new_cart
end

def apply_coupons(cart, coupons)
  if coupons != []
    coupons.each do |coupon|
      if cart.keys.include?(coupon[:item])
        item_name = coupon[:item]
        if cart[item_name][:count] >= coupon[:num]
          quotient = cart[item_name][:count] / coupon[:num]
          remainder = cart[item_name][:count] % coupon[:num]
          cart[item_name][:count] = remainder
          cart["#{item_name} W/COUPON"] = {:price => coupon[:cost].to_f/coupon[:num], :clearance => cart[item_name][:clearance], :count=>quotient*coupon[:num]}
        end
      end
    end
  end
  cart

end

def apply_clearance(cart)
  cart.each do |item, details|
    if details[:clearance] == true
      details[:price] = (details[:price]*0.8*100).to_i.to_f/100
    end
  end
  # code here
end

def checkout(cart, coupons)

  processed_cart = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  subtotal =0
  processed_cart.each do |name,details|
    subtotal += details[:price]*details[:count]
  end
  if subtotal > 100
    return 0.9 * subtotal
  else
   return subtotal
  end
end
