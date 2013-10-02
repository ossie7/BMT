Popup = {}
Popup.__index = Popup

function Popup.new(title, body, button, action, face)
  self = setmetatable({}, Popup)

  self.title = title
  self.body = body
  self.button = button
  self.action = action
  self.face = face

  return self
end