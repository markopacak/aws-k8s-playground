import string

import torch

N_HIDDEN = 128
ALL_LETTERS = string.ascii_letters + "-"


def letter_to_tensor(letter: str) -> torch.Tensor:
    """
    :param letter:
    :return:
    """
    tensor = torch.zeros(1, len(ALL_LETTERS))
    letter_idx = ALL_LETTERS.find(letter)
    tensor[0][letter_idx] = 1
    return tensor


def line_to_tensor(line: str) -> torch.Tensor:
    tensor = torch.zeros(len(line), 1, len(ALL_LETTERS))

    for i, letter in enumerate(line):
        letter_idx = ALL_LETTERS.find(letter)
        tensor[i][0][letter_idx] = 1

    return tensor
