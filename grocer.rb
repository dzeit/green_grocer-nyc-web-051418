require 'pry'

def consolidate_cart(cart)
  cart.each_with_object({}) do |key, value|
    key.each do |type, attributes|
      if value[type]
      attributes[:count] += 1
      else 
      attributes[:count] = 1 
      value[type] = attributes 
      end 
    end 
  end
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon_item = coupon[:item] # the key from the coupon hash
    if cart[coupon_item] && cart[coupon_item][:count] >= coupon[:num]
      if cart["#{coupon_item} W/COUPON"] 
        cart["#{coupon_item} W/COUPON"][:count] += 1 
      else
         cart["#{coupon_item} W/COUPON"] = {:price => coupon[:cost], :count => 1, :clearance => cart[coupon_item][:clearance]} 
     end 
     cart[coupon_item][:count] -= coupon[:num]
   end
  end 
 cart 
end

def apply_clearance(cart)
  cart.each do |item, attributes|
    if attributes[:clearance]
      discounted_price = attributes[:price] * 0.80  
      attributes[:price] = discounted_price.round(2)
    end 
  end 
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  couponed_consolidated = apply_coupons(consolidated_cart, coupons) # changed the argument because we want to apply the consolidated cart and not the original cart.
  final_cart = apply_clearance(couponed_consolidated) # ibid
  total = 0 
  final_cart.each do |items, attributes|
    total += attributes[:price] * attributes[:count]
  end 
  if total >= 100 
    total = total * 0.90
  end 
  total 
end
