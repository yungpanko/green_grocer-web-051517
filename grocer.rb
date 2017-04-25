def consolidate_cart(cart)
  # code here
  consolidated_cart = {}
  cart.each do |hash|
    hash.each do |item, attributes|
      unless consolidated_cart[item]
        consolidated_cart[item] = attributes
        consolidated_cart[item][:count] = 1
      else
        consolidated_cart[item][:count] += 1
      end
    end
  end
  consolidated_cart
end

def apply_coupons(cart, coupons)
  # code here
  coupons_applied = {}
  cart.map do |item, info|
    coupons.each do |coupon|
      if coupon[:item] == item && info[:count] % coupon[:num] == 0
        coupons_applied["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => (info[:count]/coupon[:num])}
        coupons_applied[item] = info
        coupons_applied[item][:count] = 0
      elsif coupon[:item] == item && info[:count] % coupon[:num] != 0 && info[:count] > coupon[:num]
        coupons_applied["#{item} W/COUPON"] = {:price => coupon[:cost], :clearance => info[:clearance], :count => (info[:count]/coupon[:num])}
        coupons_applied[item] = info
        coupons_applied[item][:count] -= (info[:count]/coupon[:num] * coupon[:num])
      end
    end
    coupons_applied[item] = info
  end
coupons_applied
end

def apply_clearance(cart)
  # code here
  clearance_prices = {}
  cart.each do |item, info|
    clearance_prices[item] = info
    if info[:clearance]
      clearance_prices[item][:price] = (info[:price] * 0.8).round(2)
    end
  end
  clearance_prices
end

def checkout(cart, coupons)
  # code here
  total_cost = 0
  cart = consolidate_cart(cart)
  if coupons != nil
    cart = apply_coupons(cart, coupons)
  end
  cart = apply_clearance(cart)
  cart.each do |item, info|
    total_cost += info[:price] * info[:count]
  end
  if total_cost > 100
    total_cost = (total_cost * 0.9).round(2)
  end
  total_cost
end
