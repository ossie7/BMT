Popup = {}
Popup.__index = Popup

function Popup.new(title, body, button, action)
  self = setmetatable({}, Popup)

  self.title = title
  self.body = body
  self.button = button
  self.action = action

  return self
end