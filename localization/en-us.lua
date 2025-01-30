return {
	["descriptions"] = {
		["Joker"] = {
			["j_cs_broken_drone"] = {
				["name"] = "Broken Drone",
				["text"] = {
					"If this Joker is {C:attention}copied{},",
					"it gains {X:mult,C:white}X0.75{} Mult and",
					"destroys any Joker attempting",
					"to {C:attention}copy{} it",
					"{C:inactive}(Currently {X:mult,C:white}X1.5 {C:inactive} Mult)",
				}
			},
			["j_cs_flipper"] = {
				["name"] = "Flipper",
				["text"] = {
					"Before scoring, played {C:attention}6s{}",
					"turns into {C:attention}9s{} and vice versa",
					"If both ranks are present,",
					"turns them into the rank that",
					"there is {C:attention}more of{} in play",
				}
			},
			["j_cs_trap"] = {
				["name"] = "Trap",
				["text"] = {
					"When this Joker is obtained,",
					"{C:attention}#1#{} {C:inactive}[#4#]{} random cards",
					"in your deck become {C:attention}fake{}",
					"Gains {C:chips}+#2#{} Chips per hand",
					"played without {C:attention}fake{} cards,",
					"otherwise {C:attention}halves{} current Chips",
					"{C:inactive}(Currently{} {C:chips}+#3#{} {C:inactive}Chips){}",
				}
			},
			["j_cs_bugged_trap"] = {
				["name"] = "Bugged Trap",
				["text"] = {
					"{C:green}#1# in #2#{} chance for this Joker",
					"to retrigger the {C:attention}Joker{} to the left",
					"each time up to {C:attention}#3#{} times",
					"{C:inactive}(Luck-altering Jokers affect{}",
					"{C:inactive}first retrigger only){}",
				},
				["unlock"] = {
                    "Have the Joker {C:attention}Trap{}",
                    "repeat {C:attention}1 or more{} times",
                },
			},
			["j_cs_destroyer"] = {
				["name"] = "Destroyer",
				["text"] = {
					"Destroys first scored",
					"card {C:attention}directly above #1#{}",
					"{s:0.8}Rank changes each round{}",
				}
			},
			["j_cs_bend_down"] = {
				["name"] = "Bend Down",
				["text"] = {
					"Decreases Blind size",
					"by {C:attention}% of discards{}",
					"remaining",
				}
			},
			["j_cs_damage"] = {
				["name"] = "Damage",
				["text"] = {
					"If {C:attention}poker hand{} is a",
					"{C:attention}Three of a Kind{},",
					"destroys every {C:attention}other{}",
					"card held {C:attention}in hand{}",
				}
			},
			["j_cs_four_walls"] = {
				["name"] = "Four Walls",
				["text"] = {
					"When {C:attention}Small Blind{} is selected,",
					"{C:attention}blocks{} the first cards",
					"drawn in your hand",
					"This Joker gains {C:mult}+#2#{} Mult",
					"when triggered",
					"{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}Mult){}",
				}
			},
			["j_cs_restoration"] = {
				["name"] = "Restoration",
				["text"] = {
					"Restores debuffed",
					"cards every {C:attention}#1#{} {C:inactive}[#2#]{}",
					"scoring cards played",
					"{C:inactive}(Includes Joker cards){}",
					"{C:inactive}(Dispels self-debuffs){}"
				}
			},
			["j_cs_move_up"] = {
				["name"] = "Keeper's Move Up",
				["text"] = {
					"Gives {C:cs_keeper}Rank Seal{} to",
					"the {C:attention}highest{} scoring",
					"cards played",
				},
				["unlock"] = {
                    "{E:1,s:1.3}?????",
                },
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
			["j_cs_upwards_escalator"] = {
				["name"] = "Upwards Escalator",
				["text"] = {
					"Gains {C:mult}+#2#{} Mult or",
					"{C:mult}+#3#{} Mult at the end",
					"of every {C:attention}round{}",
					"{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}Mult){}",
				}
			},
			["j_cs_downwards_escalator"] = {
				["name"] = "Downwards Escalator",
				["text"] = {
					"{C:blue}-#1#{} hands each round,",
					"prevents {C:attention}Ante{} from",
					"going up after",
					"beating a {C:attention}Boss Blind{}",
					"{S:1.1,C:red,E:2}self destructs{}",
				}
			},
			["j_cs_escalator_fan"] = {
				["name"] = "escalator_fan",
				["text"] = {
					"{C:attention}Scaling{} Jokers each",
					"give {X:mult,C:white}X#1#{} Mult",
				},
				["unlock"] = {
                    "{E:1,s:1.3}?????",
                },
			},
			["j_cs_strider"] = {
				["name"] = "Strider",
				["text"] = {
					"If {C:attention}first hand{} of round",
					"has only {C:attention}1{} card, add a",
					"{C:red}Red Seal{} to it or change",
					"it to a {C:cs_drifter}Lift Seal{} if it does",
					"already have one",
				}
			},
			["j_cs_random_teleport"] = {
				["name"] = "Random Teleport",
				["text"] = {
					"{C:green}#1# in #2#{} chance for this Joker",
					"to create {C:attention}#3#{} random {C:attention}temporary{}",
					"{C:tarot}Tarot{} or {C:spectral}Spectral{} #4#",
					"at the start of the {C:attention}shop{}",
					"{C:inactive}(Must have room){}",
				}
			},
		},
		["Alignment"] = {
			["ali_locked"] = {
                ["name"] = "Unknown",
                ["text"] = {
                    "Find this Alignment",
                    "in Morph Packs",
                }
			},
			["ali_cs_patron"] = {
				["name"] = "Patron Morph",
				["text"] = {
					"Allows using",
					"{X:cs_patron,C:black}Patron{} aligned",
					"Jokers",
				},
			},
			["ali_cs_wicked"] = {
				["name"] = "Wicked Morph",
				["text"] = {
					"Allows using",
					"{X:cs_wicked,C:black}Wicked{} aligned",
					"Jokers",
				},
			},
			["ali_cs_joker"] = {
				["name"] = "Joker Morph",
				["text"] = {
					"Allows using",
					"{X:cs_joker,C:black}Joker{} aligned",
					"Jokers",
				},
			},
		},
		["Enhanced"] = {
			["m_cs_fake"] = {
				["name"] = "Fake Card",
				["text"] = {
					"Scores negative of",
					"base Chips value",
					"Can't be traced",
					"unless triggered",
				},
			},
		},
		["Voucher"] = {
			["v_cs_bender"] = {
				["name"] = "Bender",
				["text"] = {
					"{C:attention}Permanently{} reduces",
					"Blind {C:attention}size{} by {C:green}#1#%{}",
				}
			},
			["v_cs_bending_the_rules"] = {
				["name"] = "Bending the Rules",
				["text"] = {
					"{C:attention}Permanently{} reduces",
					"Blind {C:attention}size{} by {C:green}#1#%{}",
				},
				["unlock"] = {
                    "Win a {C:attention}round{} with",
					"a score lesser",
					"than {C:attention}104%{} of",
					"required chips",
                },
			}
		},
		["Other"] = {
			["cs_fake_card"] = {
				["name"] = "Fake Card",
				["text"] = {
					"Scores negative of",
					"base Chips value",
					"Can't be traced",
					"unless triggered",
				}
			},
			["cs_rank_seal"] = {
				["name"] = "Rank Seal",
				["text"] = {
                    "When this card",
                    "is played and scores,",
                    "increase rank by {C:attention}1{}",
                    "{C:inactive}(Cannot be applied to Aces){}",
				}
			},
			["cs_lift_seal"] = {
				["name"] = "Lift Seal",
				["text"] = {
                    "Retrigger this",
                    "card {C:attention}2{} times",
				}
			},
			["cs_basic"] = {
				["name"] = "Basic Card",
				["text"] = {
					"No Enhancements/Editions/Seals"
				}
			},
			["cs_temporary"] = {
				["name"] = "Temporary Card",
				["text"] = {
					"Will {C:red}disappear{} when",
					"the specified context",
					"is over",
				}
			},
			["cs_blocked"] = {
				["name"] = "Blocked Card",
				["text"] = {
					"This card is {C:attention}stuck{} in",
					"its current card area",
				}
			},
			["cs_patron_aligned"] = {
				["name"] = "Patron Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_patron,C:black}Patron{}",
				}
			},
			["cs_joker_aligned"] = {
				["name"] = "Joker Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_joker,C:black}Joker{}",
				}
			},
			["cs_wicked_aligned"] = {
				["name"] = "Wicked Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_wicked,C:white}Wicked{}",
				}
			},
			["cs_keeper_aligned"] = {
				["name"] = "Keeper Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {X:cs_keeper,C:white}Keeper{}",
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
					"morphed into {X:cs_hacker, C:black}Hacker{}",
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
					"morphed into {X:cs_drifter, C:black}Drifter{}",
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
					"morphed into {X:cs_spectre, C:black}Spectre{}",
				}
			},
			["cs_chameleon_aligned"] = {
				["name"] = "Chameleon Aligned",
				["text"] = {
					"Can be used while",
					"morphed into {C:cs_chameleon}Chameleon",
				}
			},
			["undiscovered_alignment"] = {
				["name"] = "Undiscovered",
				["text"] = {
					"Find this Alignment",
					"in Morph Packs",
				},
			},
		},
	},
	["misc"] = {
		["dictionary"] = {
			-- ["b_alignment_cards"] = "Alignment",
			["k_alignment"] = "Alignment",
			["b_alignments"]="Alignments",
			-- Terms
			["cs_card"] = "card",
			["cs_cards"] = "cards",
			["cs_consumable"] = "consumable",
			["cs_consumables"] = "consumables",
			["cs_tarot"] = "Tarot",
			["cs_tarots"] = "Tarots",
			["cs_spectral"] = "Spectral",
			["cs_spectrals"] = "Spectrals",
			["cs_planet"] = "Planet",
			["cs_planets"] = "Planets",
			["cs_blind_size"] = "Blind size",
			["cs_active"] = "active!",
			["cs_inactive"] = "inactive",
			-- Neutral
			["cs_false"] = "False",
			["cs_smh"] = "Smh",
			-- Joker
			["cs_flipped"] = "Flipped!",
			["cs_faking_cards"] = "Don't peek!",
			["cs_fake_played"] = "Hahaha!",
			["cs_lame"] = "Lame",
			["cs_fall_again"] = "Fall Again!",
			-- Wicked
			["cs_destroyed"] = "Destroyed!",
			["cs_damaged"] = "Damaged!",
			["cs_bend"] = "Bend!",
			["cs_blocked"] = "Blocked!",
			["cs_freed"] = "Free!",
			["cs_nuh_uh"] = "Nuh Uh!",
			-- Patron
			["cs_created"] = "Created!",
			-- Drifter
			["cs_boosted"] = "Boosted!",
			["cs_boosted_again"] = "Boosted again!",
			["cs_lift"] = "Rise!",
			-- Keeper
			["cs_restored"] = "Restored!",
			["cs_promoted"] = "Promoted!",
			-- Hacker
			["cs_slowed_down"] = "Slowed Down!",
			["cs_scaling"] = "Scaling",
			-- Music stuff
			["b_music_selector"] = "Soundtrack",
			["ml_music_selector_opt"] = {
				"Balatro OST by LouisF",
				"Climbing theme",
			},
		},
		["v_dictionary"] = {
			["cs_just_chips"] = "#1#",
		},
		["labels"] = {
			["cs_lift_seal"] = "Lift Seal",
			["cs_rank_seal"] = "Rank Seal",
			["cs_temporary"] = "Temporary",
			["cs_blocked"] = "Blocked",
		},
	},
}