"""
bending_energy.py
=================
Compute bending energy from a director field.

Syntax
------
python bending_energy.py directorDir

directorDir: the director field, [M x N x 2].

Edit
----
Jan 19, 2023 -- Initial commit.
"""

def compute_gradient(field):
    """
    Compute the gradient, divergence andn curl of a 2D field.

    Args:
    field -- the input 2D field, [M x N x 2].

    Returns:
    gradient -- the gradient of the field, [M x N x 2 x 2].
    """
    grad_x = np.gradient(field[::step, ::step, 0])
    grad_y = np.gradient(field[::step, ::step, 1])
    grad = np.array([grad_x, grad_y]).transpose(1, 2, 0, 3)
    div = grad_x[0] + grad_y[1]
    curl = grad_y[0] - grad_x[1]

    return grad, div, curl

def compute_bending_energy(field):
    """
    Compute the bending energy of a 2D field.

    Args:
    field -- the input 2D field, [M x N x 2].

    Returns:
    bending_energy -- the bending energy of the field, [M x N].
    """
    grad, div, curl = compute_gradient(field)
    bending_energy = div**2 + curl**2

    return bending_energy

def angle_to_director(angle_8_bit):
    """
    Convert an 8-bit angle image to a director field.

    Args:
    angle_8_bit -- the input 8-bit angle image, [M x N].

    Returns:
    director -- the output director field, [M x N x 2].
    """
    angle = angle_8_bit * np.pi / 255 - np.pi / 2
    director = np.array([np.cos(angle), np.sin(angle)]).transpose(1, 2, 0)

    return director


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Compute bending energy from a director field.")
    parser.add_argument("directorDir", help="the director field, [M x N x 2].")
    args = parser.parse_args()

    # process the filename
    folder, filename = os.path.split(args.directorDir)
    name, ext = os.path.splitext(filename)
    mainfolder = os.path.split(imgfolder)[0]
    savefolder = os.path.join(mainfolder, "bending_energy")

    # compute bending energy
    angles = np.load(args.directorDir)
    directors = angle_to_director(angles)
    energy_list = []
    for director in directors:
        bending_energy = compute_bending_energy(director)
        energy_list.append(bending_energy)
    
    # save bending energy data
    df = pd.DataFrame({"frame": range(len(energy_list)), "bending_energy": energy_list})
    df.to_csv(os.path.join(savefolder, name+".csv"), index=False)