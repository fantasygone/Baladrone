return {
	["descriptions"] = {
		["Joker"] = {
			["j_cs_broken_drone"] = {
				["name"] = "Broken Drone",
				["text"] = {
					"Destroys Jokers that try",
					"to copy this Joker",
					"Gain {X:mult,C:white}X#1#{} Mult per card",
					"destroyed this way",
					"{C:inactive}(Currently {X:mult,C:white}X#2# {C:inactive} Mult)",
				}
			},
			["j_cs_flipper"] = {
				["name"] = "Flipper",
				["text"] = {
					"Before scoring, played {C:attention}6s{}",
					"turns into {C:attention}9s{} and vice versa",
					"If both ranks are present,",
					"turns them into the rank that",
					"there is more of in play",
				}
			},
			["j_cs_trap"] = {
				["name"] = "Trap",
				["text"] = {
					"When this Joker is obtained,",
					"{C:attention}#1#{} {C:inactive}[#4#]{} random cards",
					"in your deck become {C:attention}fake{}",
					"Gains {C:chips}+#2#{} Chips per",
					"consecutive hand played",
					"without {C:attention}fake{} cards",
					"if there are any",
					"{C:inactive}(Currently{} {C:chips}+#3#{} {C:inactive}Chips){}",
				}
			},
			["j_cs_destroyer"] = {
				["name"] = "Destroyer",
				["text"] = {
					"Destroys first scored",
					"card directly above {C:attention}#1#{}",
					"and gains {C:mult}+#2#{} Mult",
					"{s:0.8}Rank changes when triggered",
					"{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
				}
			},
			["j_cs_creator"] = {
				["name"] = "Creator",
				["text"] = {
					"On {C:attention}first hand{} of round,",
					"creates a {C:attention}basic{} copy of",
					"the first card played",
					"increased by {C:attention}#1# rank{}",
				}
			},
		},
		["Other"] = {
			["cs_basic"] = {
				["name"] = "Basic Card",
				["text"] = {
					"Won't retain any",
					"edition and/or enhanchment"
				}
			},
			["cs_fake"] = {
				["name"] = "Fake Card",
				["text"] = {
					"Scores negative of",
					"base Chips value",
					"Can't be traced"
				}
			},
			["cs_patron_aligned"] = {
				["name"] = "Patron Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_patron, C:cs_patron}Patron",
				}
			},
			["cs_joker_aligned"] = {
				["name"] = "Joker Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_joker, C:cs_joker}Joker",
				}
			},
			["cs_wicked_aligned"] = {
				["name"] = "Wicked Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_wicked}Wicked{}",
				}
			},
			["cs_keeper_aligned"] = {
				["name"] = "Keeper Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_keeper}Keeper",
				}
			},
			["cs_muggle_aligned"] = {
				["name"] = "Muggle Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_muggle, C:cs_muggle}Muggle",
				}
			},
			["cs_hacker_aligned"] = {
				["name"] = "Hacker Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_hacker, C:cs_hacker}Hacker",
				}
			},
			["cs_thief_aligned"] = {
				["name"] = "Thief Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_thief}Thief",
				}
			},
			["cs_archon_aligned"] = {
				["name"] = "Archon Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_archon}Archon",
				}
			},
			["cs_drifter_aligned"] = {
				["name"] = "Drifter Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_drifter}Drifter",
				}
			},
			["cs_heretic_aligned"] = {
				["name"] = "Heretic Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_heretic}Heretic",
				}
			},
			["cs_spectre_aligned"] = {
				["name"] = "Spectre Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_spectre}Spectre",
				}
			},
			["cs_chameleon_aligned"] = {
				["name"] = "Chameleon Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_chameleon}Chameleon",
				}
			},
		},
	},
	["misc"] = {
		["dictionary"] = {
			["cs_active"] = "active!",
			["cs_inactive"] = "inactive",
			["cs_false"] = "False",
			["cs_smh"] = "Smh",
			["cs_flipped"] = "Flipped!",
			["cs_faking_cards"] = "Don't peek!",
			["cs_fake_played"] = "Hahaha!",
			["cs_lame"] = "Lame",
			["cs_destroyed"] = "Destroyed!",
			["cs_created"] = "Created!",
			["cs_just_chips"] = "Created!",
		},
		["v_dictionary"] = {
			["cs_just_chips"] = "#1#",
		},
	},
}