#ifndef MOVEMENT_TUNES_CONFIG_H_
#define MOVEMENT_TUNES_CONFIG_H_

<% for def, val in pairs(defines) do %>
#define <%- def %> <%- val %>
<% end %>

#endif
