return {
	descriptions = {
		Joker = {
			j_cs_broken_drone = {
				name = "Broken Drone",
				text = {
					"If this Joker is {C:attention}copied{},",
					"it gains {X:mult,C:white}X0.75{} Mult and",
					"destroys any Joker attempting",
					"to {C:attention}copy{} it",
					"{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
				}
			},
			j_cs_flipper = {
				name = "Flipper",
				text = {
					"Before scoring, played {C:attention}6s{}",
					"turns into {C:attention}9s{} and vice versa",
					"If both ranks are present,",
					"turns them into the rank that",
					"there is {C:attention}more of{} in play",
				}
			},
			j_cs_trap = {
				name = "Trap",
				text = {
					"When this Joker is obtained,",
					"{C:attention}#1#{} {C:inactive}[#4#]{} random cards",
					"in your deck become {C:attention}fake{}",
					"Gains {C:chips}+#2#{} Chips per hand",
					"played without {C:attention}fake{} cards,",
					"otherwise {C:attention}halves{} current Chips",
					"{C:inactive}(Currently{} {C:chips}+#3#{} {C:inactive}Chips){}",
				}
			},
			j_cs_bugged_trap = {
				name = "Bugged Trap",
				text = {
					"{C:green}#1# in #2#{} chance for this Joker",
					"to retrigger the {C:attention}Joker{} to the left",
					"each time up to {C:attention}#3#{} times",
					"{C:inactive}(Luck-altering Jokers affect{}",
					"{C:inactive}first retrigger only){}",
				},
				unlock = {
                    "Have the Joker {C:attention}Trap{}",
                    "repeat {C:attention}1 or more{} times",
                },
			},
			j_cs_disco = {
				name = "Disco",
				text = {
					"Disables {C:attention}Boss Blind{} if",
					"scoring hand contains",
					"at least {C:attention}#1#{} cards",
					"and they all have",
					"different {C:dark_edition}editions{}",

				},
				unlock = {
                    "Have the Joker {C:attention}Trap{}",
                    "repeat {C:attention}1 or more{} times",
                },
			},
			j_cs_flip_right = {
				name = "Flip Right",
				text = {
					"When not in a {C:attention}Blind{},",
					"{C:attention}flips over{} the Joker",
					"to the right for {C:attention}#2#{} Mana",
					"{X:mult,C:white}X#4#{} Mult if the {C:attention}other{}",
					"{C:attention}Jokers{} are all {C:attention}flipped over{}",
					"{C:inactive}(MANA:{} {C:attention}#1#{}{C:inactive}/{}{C:attention}#3#{}{C:inactive}){}",
				},
			},
			j_cs_destroyer = {
				name = "Destroy Above",
				text = {
					"Destroys first scored",
					"card {C:attention}directly above #1#{}",
					"{s:0.8}Rank changes each round{}",
				}
			},
			j_cs_bend_down = {
				name = "Bend Down",
				text = {
					"Decreases Blind size",
					"by {C:attention}% of discards{}",
					"remaining",
				}
			},
			j_cs_damage = {
				name = "Damage",
				text = {
					"If {C:attention}poker hand{} is a",
					"{C:attention}Three of a Kind{},",
					"destroys every {C:attention}other{}",
					"card held {C:attention}in hand{}",
				}
			},
			j_cs_four_walls = {
				name = "Four Walls",
				text = {
					"When {C:attention}Small Blind{} is selected,",
					"{C:attention}blocks{} the first cards",
					"drawn in your hand",
					"This Joker gains {C:mult}+#2#{} Mult",
					"when triggered",
					"{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}Mult){}",
				}
			},
			j_cs_vicious_joker = {
				name = "Vicious Joker",
				text = {
					"Destroys scoring {C:attention}enhanced{}",
					"cards and earn {C:money}$#1#{} for each",
				}
			},
			j_cs_new_destroyer = {
				name = "Destroyer",
				text = {
					"On {C:attention}first hand{} of round,",
					"destroys scoring hand",
					"if {C:attention}hand level{} is equal to",
					"the current {C:attention}Ante{}",
				}
			},
			j_cs_bend_up = {
				name = "Bend Up",
				text = {
					"{C:blue}-#1#{} level to each hand",
					"On {C:attention}first hand{} of round,",
					"{C:attention}temporarily{} upgrades a",
					"random hand with the",
					"{C:attention}lowest level{} to match the",
					"{C:attention}highest{} hand level you own"
				}
			},
			j_cs_restoration = {
				name = "Restoration",
				-- text = {
				-- 	"Restores debuffed",
				-- 	"cards every {C:attention}#1#{} {C:inactive}[#2#]{}",
				-- 	"scoring cards played",
				-- 	"{C:inactive}(Includes Joker cards){}",
				-- 	"{C:inactive}(Dispels self-debuffs){}"
				-- }
				text = {
					"Every {C:attention}#1#{} {C:inactive}[#2#]{} cards played,",
					"restores debuffed cards",
					"for {C:attention}#5#{} Mana per card",
					"{C:inactive}(Includes Joker cards){}",
					"{C:inactive}(Dispels self-debuffs){}",
					"{C:inactive}(MANA:{} {C:attention}#3#{}{C:inactive}/{}{C:attention}#4#{}{C:inactive}){}",
				}
			},
			j_cs_move_up = {
				name = "Keeper's Move Up",
				text = {
					"Gives {C:cs_keeper}Rank Seal{} to",
					"the {C:attention}highest{} scoring",
					"cards played",
				},
				unlock = {
                    "{E:1,s:1.3}?????",
                },
			},
			j_cs_random_move = {
				name = "Random Move",
				text = {
					"If played hand has",
					"only {C:attention}1{} card, either",
					"{C:attention}increases/decreases{} the",
					"rank or turns it into",
					"the {C:attention}next/previous{} suit",
				},
			},
			j_cs_creator = {
				name = "Creator",
				text = {
					"On {C:attention}first hand{} of round,",
					"creates a {C:attention}basic{} copy of",
					"the first card played",
					"increased by {C:attention}#1# rank{}",
				}
			},
			j_cs_link = {
				name = "Link",
				text = {
					"If played hand scores",
					"{C:attention}below{} average, adjusts score",
					"to average once {C:attention}per ante{}",
					"{C:inactive}(Current average score:{} {C:cs_multchips}#1#{}{C:inactive}){}"
				}
			},
			j_cs_portal = {
				name = "Portal",
				text = {
					"{C:blue}-2{} card selection",
					"limit each round",
					"Selects cards {C:attention}adjacent{} to",
					"{C:attention}rightmost{} and {C:attention}leftmost{}",
					"highlighted cards when",
					"playing or discarding",
					"{C:inactive}(Exceeds card selection limit){}",
				}
			},
			j_cs_call_the_orb = {
				name = "Call the Orb",
				text = {
					"When {C:attention}Small Blind{} is selected,",
					"select {C:attention}#1#{} out of {C:attention}#2#{} cards",
					"to draw after selecting",
					"the next {C:attention}Boss Blind{}",
				},
				unlock = {
                    "{E:1,s:1.3}?????",
                },
			},
			j_cs_upwards_escalator = {
				name = "Upwards Escalator",
				text = {
					"Gains {C:mult}+#2#{} Mult or",
					"{C:mult}+#3#{} Mult at the end",
					"of every {C:attention}round{}",
					"{C:inactive}(Currently{} {C:mult}+#1#{} {C:inactive}Mult){}",
				}
			},
			j_cs_downwards_escalator = {
				name = "Downwards Escalator",
				text = {
					"{C:blue}-#1#{} hands each round,",
					"prevents {C:attention}Ante{} from",
					"going up after",
					"beating a {C:attention}Boss Blind{}",
					"{S:1.1,C:red,E:2}self destructs{}",
				}
			},
			j_cs_escalator_fan = {
				name = "escalator_fan",
				text = {
					"{C:attention}Scaling{} Jokers each",
					"give {X:mult,C:white}X#1#{} Mult",
				},
				unlock = {
                    "{E:1,s:1.3}?????",
                },
			},
			j_cs_card_thief = {
				name = "Card Thief",
				text = {
					"{C:attention}Steals{} scoring hand",
					"if it's the {C:attention}most played{}",
					"Gains stolen cards'",
					"{C:chips}rank{} as Chips",
					"{C:inactive}(Currently{} {C:chips}+#1#{} {C:inactive}Chips){}",
					"{C:inactive}(Must have room){}",
				},
			},
			j_cs_steal_above = {
				name = "Steal Above",
				text = {
					"{C:attention}Steals{} first scored",
					"card {C:attention}directly above #1#{}",
					"Gains stolen cards'",
					"doubled {C:chips}rank{} as Chips",
					"{C:inactive}(Currently{} {C:chips}+#2#{} {C:inactive}Chips){}",
					"{C:inactive}(Must have room){}",
					"{s:0.8}Rank changes each round{}",
				},
			},
			j_cs_strider = {
				name = "Strider",
				text = {
					"If {C:attention}first hand{} of round",
					"has only {C:attention}1{} card, add a",
					"{C:red}Red Seal{} to it or change",
					"it to a {C:cs_drifter}Lift Seal{} if it does",
					"already have one",
				}
			},
			j_cs_random_teleport = {
				name = "Random Teleport",
				text = {
					"{C:green}#1# in #2#{} chance for this Joker",
					"to create {C:attention}#3#{} random {C:attention}temporary{}",
					"{C:tarot}Tarot{} or {C:spectral}Spectral{} #4#",
					"at the start of the {C:attention}shop{}",
					"{C:inactive}(Must have room){}",
				}
			},
			j_cs_dual_hands = {
				name = "Dual Hands",
				text = {
					"{C:green}#1# in #2#{} chance for each",
					"played hand to be",
					"retriggered {C:attention}#3#{} more #4#",
				}
			},
			j_cs_revival_point = {
				name = "Revival Point",
				text = {
                    "Sell this card to gain",
                    "back {C:blue}Hands{}, {C:red}Discards{}",
                    "and {C:money}Dollars{} that were",
					"lost after this",
					"Joker was obtained",
				}
			},
		},
		Alignment = {
			ali_cs_patron = {
				name = "Patron Morph",
				text = {
					"Allows finding",
					"{X:cs_patron,C:black}Patron{} aligned",
					"Jokers",
				},
			},
			ali_cs_wicked = {
				name = "Wicked Morph",
				text = {
					"Allows finding",
					"{X:cs_wicked,C:black}Wicked{} aligned",
					"Jokers",
				},
			},
			ali_cs_joker = {
				name = "Joker Morph",
				text = {
					"Allows finding",
					"{X:cs_joker,C:black}Joker{} aligned",
					"Jokers",
				},
			},
			ali_cs_keeper = {
				name = "Keeper Morph",
				text = {
					"Allows finding",
					"{X:cs_keeper,C:white}Keeper{} aligned",
					"Jokers",
				},
			},
			ali_cs_muggle = {
				name = "Muggle Morph",
				text = {
					"Allows finding",
					"{X:cs_muggle,C:black}Muggle{} aligned",
					"Jokers",
				},
			},
			ali_cs_hacker = {
				name = "Hacker Morph",
				text = {
					"Allows finding",
					"{X:cs_hacker,C:black}Hacker{} aligned",
					"Jokers",
				},
			},
			ali_cs_thief = {
				name = "Thief Morph",
				text = {
					"Allows finding",
					"{X:cs_thief,C:white}Thief{} aligned",
					"Jokers",
				},
			},
			ali_cs_archon = {
				name = "Archon Morph",
				text = {
					"Allows finding",
					"{X:cs_archon,C:black}Archon{} aligned",
					"Jokers",
				},
			},
			ali_cs_heretic = {
				name = "Heretic Morph",
				text = {
					"Allows finding",
					"{X:cs_heretic,C:black}Heretic{} aligned",
					"Jokers",
				},
			},
			ali_cs_drifter = {
				name = "Drifter Morph",
				text = {
					"Allows finding",
					"{X:cs_drifter,C:black}Drifter{} aligned",
					"Jokers",
				},
			},
			ali_cs_spectre = {
				name = "Spectre Morph",
				text = {
					"Allows finding",
					"{X:cs_spectre,C:black}Spectre{} aligned",
					"Jokers",
				},
			},
			ali_cs_chameleon = {
				name = "Chameleon Morph",
				text = {
					"Allows finding",
					"any aligned Joker",
					"plus its own"
				},
			},
			ali_cs_splicer = {
				name = "Splicer Morph",
				text = {
					"Allows finding",
					"{X:cs_splicer,C:black}Splicer{} aligned",
					"Jokers",
				},
			},
			ali_cs_necromancer = {
				name = "Necromancer Morph",
				text = {
					"Allows finding",
					"{X:cs_necromancer,C:white}Necromancer{} aligned",
					"Jokers",
				},
			},
			ali_cs_reaver = {
				name = "Reaver Morph",
				text = {
					"Allows finding",
					"{X:cs_reaver,C:white}Reaver{} aligned",
					"Jokers",
				},
			},
			ali_cs_gremlin = {
				name = "Gremlin Morph",
				text = {
					"Allows finding",
					"{X:cs_gremlin,C:black}Gremlin{} aligned",
					"Jokers",
				},
			},
			ali_cs_none = {
				name = "None",
				text = {
					"Starting Alignment",
					"Does nothing",
				},
			},
			ali_cs_architect = {
				name = "Architect",
				text = {
					"Select your own",
					"{C:attention}Boss Blinds{} from",
					"the collection",
				},
			},
		},
		Tarot = {
			c_cs_annihilator = {
				name = "Annihilator",
				text = {
                    "Destroys {C:attention}#1#{} selected",
                    "Joker for its {C:money}buy price{}",
                    "{C:inactive}(Ignores Eternal){}",
				},
			},
		},
		Spectral = {
			c_cs_duality = {
				name = "Duality",
				text = {
                    "Creates a {C:attention}Perishable{} copy",
                    "of a random {C:attention}non-Perishable{}",
                    "Joker and vice versa",
					"{C:inactive,s:0.9}(Removes {C:dark_edition,s:0.9}Negative{C:inactive,s:0.9} from copy)",
				},
			},
		},
		Enhanced = {
			m_cs_fake = {
				name = "Fake Card",
				text = {
					"Scores negative of",
					"base Chips value",
					"Can't be traced",
					"unless triggered",
				},
			},
		},
		Voucher = {
			v_cs_bender = {
				name = "Bender",
				text = {
					"{C:attention}Permanently{} reduces",
					"Blind {C:attention}size{} by {C:green}#1#%{}",
				}
			},
			v_cs_bending_the_rules = {
				name = "Bending the Rules",
				text = {
					"{C:attention}Permanently{} reduces",
					"Blind {C:attention}size{} by {C:green}#1#%{}",
				},
				unlock = {
                    "Win a {C:attention}round{} with",
					"a score lesser",
					"than {C:attention}104%{} of",
					"required chips",
                },
			}
		},
		Other = {
			cs_perishable_info = {
                name="Perishable",
                text={
                    "Debuffed after",
                    "{C:attention}5{} rounds",
                    "{C:inactive}({C:attention}5{C:inactive} remaining)",
                },
			},
			cs_fake_card = {
				name = "Fake Card",
				text = {
					"Scores negative of",
					"base Chips value",
					"Can't be traced",
					"unless triggered",
				}
			},
			cs_rank_seal = {
				name = "Rank Seal",
				text = {
                    "When this card",
                    "is played and scores,",
                    "increase rank by {C:attention}1{}",
                    "{C:inactive}(Cannot be applied to Aces){}",
				}
			},
			cs_lift_seal = {
				name = "Lift Seal",
				text = {
                    "Retrigger this",
                    "card {C:attention}2{} times",
				}
			},
			cs_basic = {
				name = "Basic Card",
				text = {
					"No Enhancements/Editions/Seals"
				}
			},
			cs_temporary = {
				name = "Temporary Card",
				text = {
					"Will {C:red}disappear{} when",
					"the specified context",
					"is over",
				}
			},
			cs_blocked = {
				name = "Blocked Card",
				text = {
					"This card is {C:attention}stuck{} in",
					"its current card area",
				}
			},
			cs_patron_aligned = {
				name = "Patron Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_patron,C:black}Patron{}",
				}
			},
			cs_joker_aligned = {
				name = "Joker Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_joker,C:black}Joker{}",
				}
			},
			cs_wicked_aligned = {
				name = "Wicked Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_wicked,C:white}Wicked{}",
				}
			},
			cs_keeper_aligned = {
				name = "Keeper Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_keeper,C:white}Keeper{}",
				}
			},
			cs_muggle_aligned = {
				name = "Muggle Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_muggle,C:black}Muggle{}",
				}
			},
			cs_hacker_aligned = {
				name = "Hacker Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_hacker,C:black}Hacker{}",
				}
			},
			cs_thief_aligned = {
				name = "Thief Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_thief,C:white}Thief{}",
				}
			},
			cs_archon_aligned = {
				name = "Archon Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_archon,C:black}Archon{}",
				}
			},
			cs_drifter_aligned = {
				name = "Drifter Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_drifter,C:black}Drifter{}",
				}
			},
			cs_heretic_aligned = {
				name = "Heretic Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_heretic,C:black}Heretic{}",
				}
			},
			cs_spectre_aligned = {
				name = "Spectre Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_spectre,C:black}Spectre{}",
				}
			},
			cs_chameleon_aligned = {
				name = "Chameleon Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_chameleon,C:white}Chameleon{}",
				}
			},
			cs_splicer_aligned = {
				name = "Splicer Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_splicer,C:black}Splicer{}",
				}
			},
			cs_reaver_aligned = {
				name = "Reaver Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_reaver,C:white}Reaver{}",
				}
			},
			cs_gremlin_aligned = {
				name = "Gremlin Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_gremlin,C:black}Gremlin{}",
				}
			},
			cs_necromancer_aligned = {
				name = "Necromancer Aligned",
				text = {
					"Can be found while",
					"morphed into {X:cs_necromancer,C:white}Necromancer{}",
				}
			},
			undiscovered_alignment = {
				name = "Undiscovered",
				text = {
					"Morph into this",
					"{C:cs_alignment}Alignment{} to find out",
					"what it does",
				},
			},
			-- Credits where credits are due!
			cs_tdthetv_artist = {
				name = "Art by TDtheTV",
				text = {
					"This sprite was",
					"made by {X:cs_drifter, C:black}TDtheTV{}",
				},
			},
			cs_duskilion_concept = {
				name = "Concept by Duskilion",
				text = {
					"This Joker concept was",
					"made by {X:cs_muggle,C:black}Duskilion{}",
				},
			},
			cs_goldendiscopig_concept = {
				name = "Concept by GoldenDiscoPig",
				text = {
					"This Joker concept was",
					"made by {X:cs_drifter, C:black}GoldenDiscoPig{}",
				},
			},
			cs_levthelion_concept = {
				name = "Concept by Levthelion",
				text = {
					"This Joker concept was",
					"made by {X:cs_necromancer,C:white}Levthelion{}",
				},
			},
			-- Packs
            p_cs_morph_normal_1={
                name = "Morph Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {C:cs_alignment}Alignments{} to",
                    "morph into",
                },
            },
            p_cs_morph_normal_2={
                name = "Morph Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {C:cs_alignment}Alignments{} to",
                    "morph into",
                },
            },
            p_cs_morph_normal_3={
                name = "Morph Pack",
                text = {
                    "Choose {C:attention}#1#{} of up to",
                    "{C:attention}#2#{} {C:cs_alignment}Alignments{} to",
                    "morph into",
                },
            },
			-- Alignment abilities
            cs_thief_start_ab={
                name = "Starting Ability",
                text = {
                    "Creates a {C:attention}Stash{} area",
                    "for stolen cards",
                    "{C:inactive}(5 card limit){}",
                },
            },
		},
	},
	misc = {
		dictionary = {
			-- b_alignment_cards = "Alignment",
			k_alignment = "Alignment",
			k_cs_morph_pack="Morph Pack",
			b_alignments="Alignments",
			b_morph="MORPH",
			b_call_hand="Call Hand",
			b_free_jokers_patron="These noobs need our help!",
			b_free_jokers_wicked="Destroy EVERYTHING!",
			b_free_jokers_joker="They won't see it coming!",
			b_free_jokers_keeper="Let's restore the order!",
			b_free_jokers_muggle="You probably don't need this...",
			b_free_jokers_hacker="This is fair game!",
			b_free_jokers_thief="I'll let you borrow this...",
			b_free_jokers_archon="This should be useful to you",
			b_free_jokers_drifter="To infinity and beyond!",
			b_free_jokers_heretic="Make good use of dark magic!",
			b_free_jokers_spectre="This is a temporary arrangement",
			b_free_jokers_splicer="Let's join forces!",
			b_free_jokers_necromancer="We just wanna play",
			b_free_jokers_reaver="Just don't break this",
			b_free_jokers_gremlin="WHEEEEEEEEEEE!",
			b_free_jokers_chameleon="Random Alignment go!!!",
			-- Terms
			cs_card = "card",
			cs_cards = "cards",
			cs_consumable = "consumable",
			cs_consumables = "consumables",
			cs_time = "time",
			cs_times = "times",
			cs_tarot = "Tarot",
			cs_tarots = "Tarots",
			cs_spectral = "Spectral",
			cs_spectrals = "Spectrals",
			cs_planet = "Planet",
			cs_planets = "Planets",
			cs_blind_size = "Blind size",
			cs_active = "active!",
			cs_inactive = "inactive",
			-- Neutral
			cs_false = "False",
			cs_smh = "Smh",
			cs_rank_up = "Rank Up!",
			cs_rank_down = "Rank Down!",
			cs_suit_up = "Next Suit!",
			cs_suit_down = "Previous Suit!",
			-- Joker
			cs_flipped = "Flipped!",
			cs_faking_cards = "Don't peek!",
			cs_fake_played = "Hahaha!",
			cs_lame = "Lame",
			cs_fall_again = "Fall Again!",
			b_flip = "FLIP",
			-- Wicked
			cs_destroyed = "Destroyed!",
			cs_damaged = "Damaged!",
			cs_bend = "Bend!",
			cs_blocked = "Blocked!",
			cs_freed = "Free!",
			cs_nuh_uh = "Nuh Uh!",
			cs_bend_up = "Bend Up!",
			-- Patron
			cs_created = "Created!",
			cs_averaged = "Average!",
			cs_together = "Together!",
			cs_calling = "Calling!",
			cs_called = "Called!",
			cs_call_received = "Call Received!",
			-- Drifter
			cs_boosted = "Boosted!",
			cs_boosted_again = "Boosted again!",
			cs_lift = "Rise!",
			-- Keeper
			cs_restored = "Restored!",
			cs_promoted = "Promoted!",
			b_restore = "RESTORE",
			-- Hacker
			cs_slowed_down = "Slowed Down!",
			cs_scaling = "Scaling",
			-- Thief
			b_cs_stack = "Stash",
			cs_stolen = "Stolen!",
			cs_borrowed = "Borrowed...",
			-- Necromancer
			cs_twin_is_gone = "Twin is gone!",
			-- Music stuff
			b_music_selector = "Soundtrack",
			ml_music_selector_opt = {
				"Balatro OST by LouisF",
				"Climbing theme",
			},
			-- Config
			start_with_chameleon = "Start with Chameleon",
			start_with_chameleon_desc = {
				"Chameleon will show up",
				"in the first Morph Pack",
			}
		},
		v_dictionary = {
			cs_just_chips = "#1#",
		},
		achievement_names = {
			-- Special
			ach_cs_well_aligned = "Well Aligned",
			ach_cs_full_circle = "Full Circle",
			ach_cs_perfect_circle = "Perfect Circle",
			-- Patron
			ach_cs_find_patron = "Helping The Noobs",
			ach_cs_win_with_patron = "Patron's Pride",
			-- Wicked
			ach_cs_find_wicked = "Villain Arc",
			ach_cs_win_with_wicked = "Wicked's Treason",
			-- Joker
			ach_cs_find_joker = "Stage Fright",
			ach_cs_win_with_joker = "Joker's Trick",
			ach_cs_continuous_falling = "Continuous Falling",
			-- Keeper
			ach_cs_find_keeper = "Starting From The Bottom",
			ach_cs_win_with_keeper = "Keeper's Order",
			ach_cs_top_promotion = "Top Promotion",
			-- Muggle
			ach_cs_find_muggle = "Hanging There",
			ach_cs_win_with_muggle = "Muggle's Logic",
			-- Hacker
			ach_cs_find_hacker = "White Hat",
			ach_cs_win_with_hacker = "Hacker's Exploit",
			-- Thief
			ach_cs_find_thief = "The Scheming Begins",
			ach_cs_win_with_thief = "Thief's Heist",
			-- Archon
			ach_cs_find_archon = "Newfound Knowledge",
			ach_cs_win_with_archon = "Archon's Connection",
			-- Drifter
			ach_cs_find_drifter = "Places To Be",
			ach_cs_win_with_drifter = "Drifter's Voyage",
			-- Heretic
			ach_cs_find_heretic = "Drawing A Circle",
			ach_cs_win_with_heretic = "Heretic's Curse",
			-- Spectre
			ach_cs_find_spectre = "Will-o'-the-wisp",
			ach_cs_win_with_spectre = "Spectre's Soul",
			-- Chameleon
			ach_cs_find_chameleon = "Colors At My Disposal",
			ach_cs_win_with_chameleon = "Chameleon's Guise",
			-- Splicer
			ach_cs_find_splicer = "The First Half",
			ach_cs_win_with_splicer = "Splicer's Twist",
			-- Necromancer
			ach_cs_find_necromancer = "A New Life",
			ach_cs_win_with_necromancer = "Necromancer's Rite",
			-- Reaver
			ach_cs_find_reaver = "Handle With Care",
			ach_cs_win_with_reaver = "Reaver's Reflection",
			-- Gremlin
			ach_cs_find_gremlin = "Minor Annoyance",
			ach_cs_win_with_gremlin = "Gremlin's Spiral",
			-- Architect
			ach_cs_find_architect = "I Am In Charge Now",
			ach_cs_win_with_architect = "Architect's Design",
		},
		achievement_descriptions = {
			--Special 
			ach_cs_well_aligned = {
				"Morph into every Alignment",
				"at least once",
			},
			ach_cs_full_circle = {
				"Beat any stake",
				"with each Alignment",
			},
			ach_cs_perfect_circle = {
				"Beat Gold stake",
				"with each Alignment",
			},
			-- Patron
			ach_cs_find_patron = {
				"Morph to Patron",
			},
			ach_cs_win_with_patron = {
				"Beat any stake while",
				"aligned to Patron",
			},
			-- Wicked
			ach_cs_find_wicked = {
				"Morph to Wicked",
			},
			ach_cs_win_with_wicked = {
				"Beat any stake while",
				"aligned to Wicked",
			},
			-- Joker
			ach_cs_find_joker = {
				"Morph to Joker",
			},
			ach_cs_win_with_joker = {
				"Beat any stake while",
				"aligned to Joker",
			},
			ach_cs_continuous_falling = {
				"Trigger Bugged Trap",
				"all of the three times",
			},
			-- Keeper
			ach_cs_find_keeper = {
				"Morph to Keeper",
			},
			ach_cs_win_with_keeper = {
				"Beat any stake while",
				"aligned to Keeper",
			},
			ach_cs_top_promotion = {
				"Have an Ace card",
				"with a Rank Seal",
				"within your deck",
			},
			-- Muggle
			ach_cs_find_muggle = {
				"Morph to Muggle",
			},
			ach_cs_win_with_muggle = {
				"Beat any stake while",
				"aligned to Muggle",
			},
			-- Hacker
			ach_cs_find_hacker = {
				"Morph to Hacker",
			},
			ach_cs_win_with_hacker = {
				"Beat any stake while",
				"aligned to Hacker",
			},
			-- Thief
			ach_cs_find_thief = {
				"Morph to Thief",
			},
			ach_cs_win_with_thief = {
				"Beat any stake while",
				"aligned to Thief",
			},
			-- Archon
			ach_cs_find_archon = {
				"Morph to Archon",
			},
			ach_cs_win_with_archon = {
				"Beat any stake while",
				"aligned to Archon",
			},
			-- Drifter
			ach_cs_find_drifter = {
				"Morph to Drifter",
			},
			ach_cs_win_with_drifter = {
				"Beat any stake while",
				"aligned to Drifter",
			},
			-- Heretic
			ach_cs_find_heretic = {
				"Morph to Heretic",
			},
			ach_cs_win_with_heretic = {
				"Beat any stake while",
				"aligned to Heretic",
			},
			-- Spectre
			ach_cs_find_spectre = {
				"Morph to Spectre",
			},
			ach_cs_win_with_spectre = {
				"Beat any stake while",
				"aligned to Spectre",
			},
			-- Chameleon
			ach_cs_find_chameleon = {
				"Morph to Chameleon",
			},
			ach_cs_win_with_chameleon = {
				"Beat any stake while",
				"aligned to Chameleon",
			},
			-- Splicer
			ach_cs_find_splicer = {
				"Morph to Splicer",
			},
			ach_cs_win_with_splicer = {
				"Beat any stake while",
				"aligned to Splicer",
			},
			-- Necromancer
			ach_cs_find_necromancer = {
				"Morph to Necromancer",
			},
			ach_cs_win_with_necromancer = {
				"Beat any stake while",
				"aligned to Necromancer",
			},
			-- Reaver
			ach_cs_find_reaver = {
				"Morph to Reaver",
			},
			ach_cs_win_with_reaver = {
				"Beat any stake while",
				"aligned to Reaver",
			},
			-- Gremlin
			ach_cs_find_gremlin = {
				"Morph to Gremlin",
			},
			ach_cs_win_with_gremlin = {
				"Beat any stake while",
				"aligned to Gremlin",
			},
			-- Architect
			ach_cs_find_architect = {
				"Morph to Architect",
			},
			ach_cs_win_with_architect = {
				"Beat any stake while",
				"aligned to Architect",
			},
		},
		labels = {
			cs_lift_seal = "Lift Seal",
			cs_rank_seal = "Rank Seal",
			cs_temporary = "Temporary",
			cs_blocked = "Blocked",
		},
	},
}