import java.io.*;
import java.util.*;

public class part2 {
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

  private static boolean tryGrid(List<char[]> grid, int startX, int startY) {
    int x = startX, y = startY, dir = 0, cnt = 0;

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

      if (grid.get(ny)[nx] == '#' || grid.get(ny)[nx] == 'O') {
        dir = (dir + 1) % 4;
        cnt++;
        if (cnt >= 4) {
          break;
        }
      } else {
        /////
        String cpos = x + "," + y;
        lpcnt.put(cpos, lpcnt.getOrDefault(cpos, 0) + 1);
        if (lpcnt.get(cpos) >= 100) {
          return false;
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

    return true;
  }

  private static List<char[]> listcpy(List<char[]> oldList) throws Throwable {
    List<char[]> newList = new ArrayList<>();
    for (char[] oldArr : oldList) {
      newList.add(oldArr.clone());
    }
    return newList;
  }

  public static void main(String[] args) throws Throwable {
    int x = 0, y = 0, maxX = 0, maxY = 0;

    List<char[]> grid = new ArrayList<>();
    try (BufferedReader reader = new BufferedReader(new FileReader("input.txt"))) {
      String line;
      int i = 0;
      
      while ((line = reader.readLine()) != null) {
        char[] cols = line.trim().toCharArray();

        maxY = cols.length;

        for (int j = 0; j < cols.length; j++) {
          if (cols[j] == '^') {
            x = j;
            y = i;
          }
        }

        grid.add(cols);

        i++;
      }

      maxX = i;
    }

    int result = 0;
    for (int i = 0; i < maxX; i++) {
      for (int j = 0; j < maxY; j++) {
        List<char[]> gridd = listcpy(grid);
        gridd.get(j)[i] = 'O';
        if (!tryGrid(gridd, x, y)) {
          result++;
        }
      }
    }
    System.out.println(result);
  }
}
