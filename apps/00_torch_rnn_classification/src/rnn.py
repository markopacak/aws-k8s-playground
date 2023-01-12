import torch
from torch.nn import Linear, LogSoftmax, Module


class RNN(Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(RNN, self).__init__()

        self._hidden_size = hidden_size

        self._i2h = Linear(input_size + hidden_size, hidden_size)
        self._i2o = Linear(input_size + hidden_size, output_size)
        self._softmax = LogSoftmax(dim=1)

    def forward(self, input, hidden):
        combined = torch.cat((input, hidden), 1)
        hidden = self._i2h(combined)
        output = self._i2o(combined)
        output = self._softmax(output)
        return output, hidden

    def init_hidden(self) -> torch.Tensor:
        return torch.zeros(1, self._hidden_size)
