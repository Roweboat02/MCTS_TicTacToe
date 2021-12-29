# -*- coding: utf-8 -*-
"""
Created on Sun Aug 15 16:43:31 2021

@author: noahr
"""
import pygame
import tic_tac_toe as ttt
import mcts
import enum

class Playertype(enum.Enum):
    Meat = 0
    Machine = 1

class Player:
    def __init__(self, symbol, player_type=None ):
        self.symbol = symbol
        self.player_type = player_type

    def prompt_for_move(self, game):
        if self.player_type == Playertype.Meat:
            return self.meat_prompt_for_move(game)
        elif self.player_type == Playertype.Machine:
            return self.machine_prompt_for_move(game)
        elif self.player_type is None:
            raise NameError("Player type uninitialized")

    def meat_prompt_for_move(self, game):
        move = (None,None)
        while None in move:
            if event_loop() == pygame.MOUSEBUTTONDOWN:
                move = self.mouse_to_move(game)
        return move

    def machine_prompt_for_move(self, game):
        return mcts.mcts(game, durration=0.75)

    def mouse_to_move(self, game):
        m_x, m_y = pygame.mouse.get_pos()

        row = None
        col = None

        #If within board bounds, convert cords to (row, col).
        if ((TTT_GUI.TILE_POS[0]+TTT_GUI.BOARD_POS[0]<=m_x<=TTT_GUI.TILE_POS[2]+TTT_GUI.BOARD_POS[0]+TTT_GUI.TILE_DIMENSION) and
            (TTT_GUI.TILE_POS[0] + TTT_GUI.BOARD_POS[1]<=m_y<=TTT_GUI.TILE_POS[2]+TTT_GUI.BOARD_POS[1]+TTT_GUI.TILE_DIMENSION)):

            for i in range(3):
                if TTT_GUI.TILE_POS[i]+TTT_GUI.BOARD_POS[0]<=m_x<=TTT_GUI.TILE_POS[i]+TTT_GUI.BOARD_POS[0]+TTT_GUI.TILE_DIMENSION:
                    row = i
                if TTT_GUI.TILE_POS[i]+TTT_GUI.BOARD_POS[1]<=m_y<=TTT_GUI.TILE_POS[i] + TTT_GUI.BOARD_POS[1] + TTT_GUI.TILE_DIMENSION:
                    col = i
        if (not row is None) and (not col is None) and (game[row][col] is None):
            return (row,col)
        return (None,None)

class TTT_GUI:
    #Set screen width, height, default background colour and create screen
    WIDTH, HEIGHT = 400, 400
    BACKGROUND = (100, 100, 100)
    SELECTION = (50, 150, 255)

    #Load board and tile images
    BOARD = pygame.image.load(r'assets\board.png').convert()
    TILE = [pygame.image.load(r'assets\x.png').convert(),
            pygame.image.load(r'assets\o.png').convert()]

    #Cord of board image within screen
    BOARD_POS = (42,60)
    #Cord of top left of squares relitave to board image ex/ square 0 is 7,7.
    TILE_POS = [7,110,213]
    #Tile Size is 96x96 pixel
    TILE_DIMENSION = 96

    def __init__(self):
        pygame.init()
        self.FONT = pygame.font.Font('C:\\WINDOWS\\Fonts\\DejaVuSans.ttf', 35, bold=True)

        self.player_x = Player(symbol='X')
        self.player_o = Player(symbol='O')
        self.players = [self.player_x,self.player_o]
        self.game = None

        self.screen = pygame.display.set_mode((self.WIDTH, self.HEIGHT))
        pygame.display.set_caption("Tic-Tac-Toe Monte Carlo")

        self.first_go = True

    def turn(self):
        return self.game.turn

    def game_settings(self):
        self.screen.fill(self.BACKGROUND)

        not_complete = True
        while not_complete:
            if event_loop() == pygame.MOUSEBUTTONDOWN:
                rect_list = self.game_settings_screen()
                not_complete = self.settings_click(rect_list)

        self.game_instance()

    def game_settings_screen(self):
        self.screen.fill(self.BACKGROUND,(0,0,400,45))

        rect_list = []

        x_text = self.FONT.render('X', 1, (0, 0, 0))
        x_text_rect = x_text.get_rect(center = (self.WIDTH/3, 30))
        self.screen.blit(x_text, x_text_rect)

        # 0
        x_first = self.FONT.render('First Move', 1, (0, 0, 0))
        x_first_rect = x_text.get_rect(center = (self.WIDTH/3, 60))
        pygame.draw.rect(self.screen,(85*(self.first_go), 150, 255),x_first_rect)
        self.screen.blit(x_first, x_first_rect)
        rect_list.append(x_first_rect)

        # 1
        x_human = self.FONT.render('Human', 1, (0, 0, 0))
        x_human_rect = x_text.get_rect(center = (self.WIDTH/3, 90))
        pygame.draw.rect(self.screen,(85*(bool(self.player_x.player_type)), 150, 255), x_human_rect)
        self.screen.blit(x_human, x_human_rect)
        rect_list.append(x_human_rect)

        # 2
        x_AI = self.FONT.render('AI', 1, (0, 0, 0))
        x_AI_rect = x_text.get_rect(center = (self.WIDTH/3, 120))
        pygame.draw.rect(self.screen,(85*(not bool(self.player_x.player_type)), 150, 255), x_AI_rect)
        self.screen.blit(x_AI, x_AI_rect)
        rect_list.append(x_AI_rect)


        o_text = self.FONT.render('O', 1, (0, 0, 0))
        o_text_rect = o_text.get_rect(center = (2*self.WIDTH/3, 30))
        self.screen.blit(o_text, o_text_rect)

        # 3
        o_first = self.FONT.render('First Move', 1, (0, 0, 0))
        o_first_rect = x_text.get_rect(center = (2*self.WIDTH/3, 60))
        pygame.draw.rect(self.screen,(85*(not self.first_go), 150, 255), o_first_rect)
        self.screen.blit(o_first, o_first_rect)
        rect_list.append(o_first_rect)

        # 4
        o_human = self.FONT.render('Human', 1, (0, 0, 0))
        o_human_rect = x_text.get_rect(center = (2*self.WIDTH/3, 90))
        pygame.draw.rect(self.screen,(85*(bool(self.player_x.player_type)), 150, 255), o_human_rect)
        self.screen.blit(o_human, o_human_rect)
        rect_list.append(o_human_rect)

        # 5
        o_AI = self.FONT.render('AI', 1, (0, 0, 0))
        o_AI_rect = x_text.get_rect(center = (2*self.WIDTH/3, 120))
        pygame.draw.rect(self.screen,(85*(not bool(self.player_x.player_type)), 150, 255), o_AI_rect)
        self.screen.blit(o_AI, o_AI_rect)
        rect_list.append(o_AI_rect)

        # 6
        done = self.FONT.render('done', 1, (0, 0, 0))
        done_rect = x_text.get_rect(center = (self.WIDTH/2, 150))
        pygame.draw.rect(self.screen,(0, 150, 255), done_rect)
        self.screen.blit(done, done_rect)
        rect_list.append(done_rect)

        pygame.display.update()

        return rect_list


    def settings_click(self, rect_list):
        m_x, m_y = pygame.mouse.get_pos()
        i = [i for i, rect in enumerate(rect_list) if rect.collidepoint((m_x,m_y))][0]
        if i == 0:
            self.first_go = False
        elif i == 1:
            self.player_x.player_type = Playertype.Meat
        elif i == 2:
            self.player_x.player_type = Playertype.Machine
        elif i == 3:
            self.first_go = True
        elif i == 4:
            self.player_o.player_type = Playertype.Meat
        elif i == 5:
            self.player_o.player_type = Playertype.Machine
        elif i == 6:
            return True
        return False


    def game_instance(self, first_go=True):
        self.game = ttt.TicTacToe(current_move=first_go)

    def single_round(self):
        move = self.players[self.turn()].prompt_for_move(self.game)
        self.game.make_move(move)
        self.draw_tile(move)
        self.status_message()
        pygame.display.update()

    def board_creation(self):
        self.screen.fill(self.BACKGROUND)

        self.status_message()

        self.screen.blit(self.BOARD,(self.BOARD_POS[0], self.BOARD_POS[1]))

        pygame.display.update()

    def status_message(self):
        if self.game.winner == 'tie':
            message = 'Game Draw'
        elif self.game.winner:
            message = self.game.winner+" Won! Reset?"
        else:
            message = ttt.TicTacToe.SYMBOLS[self.game.turn] + "'s Turn"
        self.screen.fill(self.BACKGROUND,(0,0,400,45))

        text = self.FONT.render(message, 1, (0, 0, 0))
        text_rect = text.get_rect(center = (self.WIDTH/2, 30))

        self.screen.blit(text, text_rect)

    def draw_tile(self, move):
        if not move is None:
            self.screen.blit(self.TILE[self.turn()],(self.TILE_POS[move[0]]+self.BOARD_POS[0], self.TILE_POS[move[1]]+self.BOARD_POS[1]))
            pygame.display.update()

    def if_has_winner(self):
        if self.game.has_winner():
            if event_loop() == pygame.MOUSEBUTTONDOWN:

                return True
        return False

    def play_the_game(self):
        self.game_settings()
        self.board_creation()
        while not self.if_has_winner():
            self.single_round()
            event_for_loop()
        self.game.reset()


def event_for_loop():
    for event in pygame.event.get():
        if event.type == (pygame.QUIT):
            pygame.quit()

def event_loop():
    run = True
    while run:
        for event in pygame.event.get():
            if event.type == (pygame.QUIT):
                run = False
            if event.type == pygame.MOUSEBUTTONDOWN:
                return pygame.MOUSEBUTTONDOWN
    pygame.quit()


if __name__ == "__main__":

    gui_board = ttt.TicTacToe()

