export interface Size {
  w: number;
  h: number;
}

export interface Point {
    x: number;
    y: number;
}

export type Vector = Point;
export type Path = Point[];

export function add(p1: Point, p2: Point): Point {
    return { x: p1.x+p2.x, y: p1.y+p2.y };
}
