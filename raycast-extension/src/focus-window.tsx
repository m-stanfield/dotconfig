import { Action, ActionPanel, Icon, List, Toast, closeMainWindow, showToast } from "@raycast/api";
import { exec } from "node:child_process";
import { existsSync } from "node:fs";
import { useEffect, useState } from "react";
import { promisify } from "node:util";

const execAsync = promisify(exec);

interface AeroWindow {
  workspace: string;
  id: string;
  app: string;
  title: string;
}

function resolveAerospace(): string {
  const candidates = ["/opt/homebrew/bin/aerospace", "/usr/local/bin/aerospace"];
  const found = candidates.find((candidate) => existsSync(candidate));
  return found ?? "aerospace";
}

async function listWindows(): Promise<AeroWindow[]> {
  const { stdout } = await execAsync(
    `${resolveAerospace()} list-windows --all --format '%{workspace} | %{window-id} | %{app-name} | %{window-title}' | sort`,
  );

  return stdout
    .trim()
    .split("\n")
    .filter((line) => line.length > 0)
    .map((line) => {
      const [workspace, id, app, ...rest] = line.split(" | ");
      return { workspace, id, app, title: rest.join(" | ") };
    })
    .filter((w) => /^\d+$/.test(w.id));
}

async function focusWorkspace(workspace: string): Promise<boolean> {
  if (!/^\d+$/.test(workspace)) throw new Error("Invalid workspace number");

  const { stdout, stderr } = await execAsync(`${resolveAerospace()} workspace -- ${workspace}`);
  if (stderr && stdout.trim().length === 0) {
    console.log(stderr)
    if (stderr.trim().startsWith(`Workspace '${workspace}' is already focused.`)) {
    } else {
      throw new Error(stderr.trim());
    }
  }
  return true;
}
function groupByWorkspace(windows: AeroWindow[]): { workspace: string; windows: AeroWindow[] }[] {
  const groups = new Map<string, AeroWindow[]>();
  for (const w of windows) {
    const list = groups.get(w.workspace) ?? [];
    list.push(w);
    groups.set(w.workspace, list);
  }
  return [...groups.entries()]
    .sort(([a], [b]) => a.localeCompare(b, undefined, { numeric: true }))
    .map(([workspace, wsWindows]) => ({ workspace, windows: wsWindows }));
}

export default function Command() {
  const [windows, setWindows] = useState<AeroWindow[]>([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {

    listWindows()
      .then(setWindows)
      .catch(async (error: Error) => {
        await showToast(Toast.Style.Failure, "Failed to list windows", error.message);
      })
      .finally(() => setIsLoading(false));
  }, []);

  const sections = groupByWorkspace(windows);

  const selectIcon = (windows: AeroWindow[]) => {
    if (windows.length === 1) {
      return Icon.AppWindow;
    }
    if (windows.length <= 2) {
      return Icon.AppWindowList;
    }
    if (windows.length <= 4) {
      return Icon.AppWindowGrid2x2;
    }
    return Icon.AppWindowGrid3x3;
  };


  return (
    <List isLoading={isLoading} searchBarPlaceholder="Filter windows by app or title…">
      {sections.length === 0 && !isLoading ? (
        <List.EmptyView title="No windows found" description="Is AeroSpace running?" />
      ) : (
        sections.map(({ workspace, windows }) => (
          <List.Item
            key={workspace}
            icon={selectIcon(windows)}
            title={workspace}
            subtitle={windows.map((w) => w.app).join(", ")}
            keywords={[workspace, ...windows.flatMap((w) => [w.app, w.title])]}
            actions={
              <ActionPanel>
                <Action
                  title="Focus Workspace"
                  icon={Icon.Eye}
                  onAction={async () => {
                    try {
                      await focusWorkspace(workspace);
                      await closeMainWindow();
                    } catch (error) {
                      await showToast(
                        Toast.Style.Failure,
                        "a",
                        error instanceof Error ? error.message : String(error),
                      );
                    }
                  }}
                />
              </ActionPanel>
            }
          />
        ))
      )}
    </List>
  );
}
