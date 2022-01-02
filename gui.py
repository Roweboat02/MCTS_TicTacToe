# -*- coding: utf-8 -*-
"""
Created on Sun Aug 15 16:43:31 2021

@author: noahr
"""
import pygame as pg
import tic_tac_toe as ttt
import tree_search as mcts
from collections import defaultdict
import sys

pg.init()
screen = pg.display.set_mode((350, 600))
pg.display.set_caption('Tic Tac Toe')

on_event = defaultdict(lambda: lambda: None)

def on_exit():
    pg.quit()
    sys.exit()

on_event[pg.QUIT] = on_exit

while True:
    for event in pg.event.get():
        on_event[event.type]()

    pg.display.update()