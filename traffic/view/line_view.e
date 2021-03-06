note
	description: "Graphical representation of a line."

class
	LINE_VIEW

inherit
	VIEW

create
	make_in_city

feature {NONE} -- Initialization

	make_in_city (a_line: LINE; a_map: MAP)
			-- Create representation of `a_line' and add it to `a_map'.	
		require
			a_map_exists: a_map /= Void
			a_map_has_line: a_map.city.lines.has (a_line)
		local
			i: INTEGER
			label: LABEL
		do
			model := a_line
			map := a_map

			create background_polyline
			background_polyline.hide
			background_polyline.set_line_width (Width * 3)
			background_polyline.set_foreground_color (Highlight_color)
			map.line_figures.extend (background_polyline)

			create polyline
			polyline.set_line_width (Width)
			map.line_figures.extend (polyline)

			create labels
			from
				i := 1
			until
				i > Label_count
			loop
				create label.make (model.number.out)
				label.text.set_font (create {EV_FONT}.make_with_values(Family_screen, Weight_regular, Shape_regular, scaled_font_size))
				label.add_to_group (map.line_figures)
				labels.extend_back (label)
				i := i + 1
			end
			update

			make_actions
			subscribe_model (polyline)
			across labels as cursor loop
				subscribe_model (cursor.item.text)
			end
		end

feature -- Access

	model: LINE
			-- Underlying model.

feature -- Status report

	model_in_city: BOOLEAN
			-- Is `model' part of `map.city'?
		do
			Result := map.city.lines.has_key (model.number)
		end

feature -- Status setting

	highlight
			-- Make visually distinct.
		do
			is_highlighted := True
			background_polyline.show
		end

	unhighlight
			-- Return to normal view.
		do
			is_highlighted := False
			background_polyline.hide
		end

feature -- Basic operations

	update
			-- Update according to the state of `model'.
		local
			i: V_ITERATOR [STATION]
			s1, s2: STATION
			segment, offset: VECTOR
			sibling_lines: V_SEQUENCE [LINE]
		do
			polyline.set_foreground_color (ev_color (model.color))
			polyline.set_point_count (0)
			background_polyline.set_point_count (0)

			if model.stations.count < 2 then
				across
					labels as li
				loop
					li.item.hide
				end
			end

			from
				i := model.stations.new_cursor
			until
				i.after or i.is_last
			loop
				s1 := i.item
				i.forth
				s2 := i.item
				sibling_lines := map.city.connecting_lines (s1, s2)
				if sibling_lines.first.stations.index_of (s2) > sibling_lines.first.stations.index_of (s1) then
					segment := s2.position - s1.position
				else
					segment := s1.position - s2.position
				end
				offset := segment.orthogonal.normalized *
					(sibling_lines.index_of (model) - 1 - (sibling_lines.count - 1) / 2) *
					(width + gap)

				polyline.extend_point (map.world_coordinate (s1.position + offset))
				polyline.extend_point (map.world_coordinate (s2.position + offset))
				background_polyline.extend_point (map.world_coordinate (s1.position + offset))
				background_polyline.extend_point (map.world_coordinate (s2.position + offset))
				if i.index = 2 then
					update_label (labels [1], s1, s2, offset)
				end
				if i.is_last then
					update_label (labels [2], s1, s2, offset)
				end
			end
		end

	remove_from_map
			-- Remove line representation from `map'.
		local
			i: INTEGER
		do
			map.line_figures.prune_all (polyline)
			map.line_figures.prune_all (background_polyline)
			from
				i := 1
			until
				i > Label_count
			loop
				labels [i].remove_from_group (map.line_figures)
				i := i + 1
			end
		end

feature -- Parameters

	Width: INTEGER = 5
			-- Line width on the map.

	Gap: INTEGER = 5
			-- Gap between two lines connecting the same stations.

	Label_count: INTEGER = 2
			-- Number of labels on a line.

feature {NONE} -- Implementation

	polyline: EV_MODEL_POLYLINE
			-- Polyline depicting the line.

	background_polyline: EV_MODEL_POLYLINE
			-- Polyline used for highlighting the line.			

	labels: V_ARRAYED_LIST [LABEL]
			-- Labels with line name.

	update_label (l: LABEL; s1, s2: STATION; offset: VECTOR)
			-- Update label `l' between stations `s1' and `s2' with line segment shifted by `offset'.
		local
			center: VECTOR
		do
			l.show
			l.text.set_text (model.number.out)
			l.text.font.set_height (scaled_font_size)
			l.fit_to_text
			l.set_background_color (polyline.foreground_color)
			if model.color.brightness < 0.6 then
				l.set_foreground_color (White)
			else
				l.set_foreground_color (Black)
			end
			center := s1.position + (s2.position - s1.position) * 0.5 + offset
			l.set_x_y (map.world_coordinate (center).x, map.world_coordinate (center).y)
		end

invariant
	polyline_exists: polyline /= Void
	labels_exists: labels /= Void
	two_labels: labels.count = Label_count
	background_polyline_exists: background_polyline /= Void
end
