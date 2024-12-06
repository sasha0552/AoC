import java.io.*;
import java.util.*;
import java.lang.Math;

public class part1 {
  private static void printGrid(List<char[]> grid) {
    {
      StringBuilder header = new StringBuilder(" ");

      for (int i = 0; i < grid.get(0).length; i++) {
        header.append((char) ('0' + (i % 10)));
      }

      System.out.println(header);
    }

    for (int i = 0; i < grid.size(); i++) {
      System.out.print(i % 10);
      System.out.println(new String(grid.get(i)));
    }

    System.out.println("===== ===== ===== ===== =====");
  }

  public static void main(String[] args) throws IOException {
    int x = 0, y = 0, dir = 0, cnt = 0;

    List<char[]> grid = new ArrayList<>();
    try (BufferedReader reader = new BufferedReader(new FileReader("input.txt"))) {
      String line;
      int i = 0;
      
      while ((line = reader.readLine()) != null) {
        char[] cols = line.trim().toCharArray();
        
        for (int j = 0; j < cols.length; j++) {
          if (cols[j] == '^') {
            x = j;
            y = i;
          }
        }

        grid.add(cols);

        i++;
      }
    }

    Map<String, Integer> lpcnt = new HashMap<>();

    while (true) {
      int nx = x, ny = y;
      if (dir == 0) {
        ny = y - 1;
      } else if (dir == 1) {
        nx = x + 1;
      } else if (dir == 2) {
        ny = y + 1;
      } else if (dir == 3) {
        nx = x - 1;
      }

      if (ny < 0 || ny >= grid.size() || nx < 0 || nx >= grid.get(ny).length) {
        break;
      }

      if (grid.get(ny)[nx] == '#') {
        dir = (dir + 1) % 4;
        cnt++;
        if (cnt == 2) {
          break;
        }
      } else {
        /////
        String cpos = x + "," + y;
        lpcnt.put(cpos, lpcnt.getOrDefault(cpos, 0) + 1);
        if (lpcnt.get(cpos) >= 100) {
          break;
        }
        if (lpcnt.get(cpos) >= 50) {
          grid.get(y)[x] = '!';
        }
        /////

        if (grid.get(y)[x] != '!') {
          grid.get(y)[x] = 'X';
        }

        x = nx;
        y = ny;

        if (dir == 0) {
          grid.get(y)[x] = '^';
        } else if (dir == 1) {
          grid.get(y)[x] = '>';
        } else if (dir == 2) {
          grid.get(y)[x] = 'v';
        } else if (dir == 3) {
          grid.get(y)[x] = '<';
        }

        cnt = 0;
      }
    }

    //printGrid(grid);

    int result = 1;
    for (char[] row : grid) {
      for (char col : row) {
        if (col == 'X') {
          result++;
        }
      }
    }
    System.out.println(result);
  }
}
